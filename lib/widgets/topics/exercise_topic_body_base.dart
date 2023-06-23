import 'package:flutter/material.dart';

import 'package:sayilar/extensions/format_bold.dart';
import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/question.dart';
import 'package:sayilar/widgets/topics/exercise_topic.dart';

/// A class supplying base functionality for the body of [ExerciseTopic]s.
///
/// In particular this leaves the content of the actual body abstract, but
/// supplies the builder with the current [Question] that should be shown to the
/// user and provides a mechanism for checking an answer that was put in by the
/// user, which automatically shows whether the answer was correct or not and
/// handles moving on to the next [Question].
abstract class ExerciseTopicBodyBase extends StatefulWidget {
  /// Create a new [ExerciseTopicBodyBase].
  const ExerciseTopicBodyBase({
    super.key,
    required this.exercise,
    this.snackBarHeight = 120.0,
    this.cooldownDuration = const Duration(seconds: 5),
  });

  /// The [Exercise] to be presented in this topic body.
  final Exercise exercise;

  /// The visual height of the [SnackBar] being shown after checking an answer.
  final double snackBarHeight;

  /// How long the latest [Question] remains on screen after being answered.
  ///
  /// After being answered, the latest [Question] will still be shown for this
  /// [Duration] before being replaced by the next [Question]. In that time the
  /// answer can be assessed and reflected upon by the user.
  final Duration cooldownDuration;
}

/// The [State] of an [ExerciseTopicBodyBase].
///
/// This is what actually supplies all of the base functionality for the bodies
/// of [ExerciseTopic]s. Implementing classes must override [build] and are
/// expected to return some interface, that displays the [currentQuestion] and
/// allows the user to put in an answer to that question. After entering,
/// [checkAnswer] should be called with that answer, which will automatically
/// show whether it was correcr or not and handle moving on to the next
/// question.
abstract class ExerciseTopicBodyBaseState<T extends ExerciseTopicBodyBase>
    extends State<T> with SingleTickerProviderStateMixin {
  /// Shorthand getter for [ExerciseTopicBodyBase.exercise].
  Exercise get exercise => widget.exercise;

  /// Shorthand getter for [ExerciseTopicBodyBase.snackBarHeight].
  double get snackBarHeight => widget.snackBarHeight;

  /// Shorthand getter for [ExerciseTopicBodyBase.cooldownDuration].
  Duration get cooldownDuration => widget.cooldownDuration;

  /// The [Question] that should currently be shown to the user.
  Question get currentQuestion => _currentQuestion;
  late Question _currentQuestion;

  /// Whether this topic body's interface should currently be enabled for input.
  ///
  /// Importantly, when this is false, the user must not be able to do anything
  /// that would lead to [checkAnswer] being called.
  bool get inputEnabled => _inputEnabled;
  bool _inputEnabled = true;

  /// A handle on a potential [SnackBar] being shown by this widget.
  ScaffoldFeatureController? _currentSnackBar;

  /// The cooldown animation active after answering a question.
  ///
  /// See [ExerciseTopicBodyBase.cooldownDuration] for more information.
  late AnimationController _cooldown;

  @override
  void initState() {
    super.initState();

    _currentQuestion = exercise.nextQuestion();

    _cooldown = AnimationController(
      duration: cooldownDuration,
      vsync: this,
    );

    // Close the snackbar opened by this widget after the cooldown has run out,
    // if it hasn't already been closed before.
    _cooldown.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentSnackBar?.close();
      }
    });
  }

  @override
  void deactivate() {
    // If there is still a snackbar opened by this widget when it is being
    // deactivated (e.g. when browsing back), close that snackbar.
    _currentSnackBar?.close();

    super.deactivate();
  }

  @override
  void dispose() {
    _cooldown.dispose();

    super.dispose();
  }

  /// Check whether the answer put in by the user is correct or not.
  ///
  /// Notify the user about whether the answer they put in was correct or not by
  /// showing a [SnackBar]. Proceed to the next question when ther user taps the
  /// _Next_ button or automatically after the [cooldownDuration] (which can be
  /// delayed by holding down on the [SnackBar]). If any user interface state
  /// needs to be updated when proceeding to the next question, this can be done
  /// in [onNextQuestion].
  void checkAnswer(String answer, [VoidCallback? onNextQuestion]) async {
    // Disable the text field for further input during the cooldown.
    setState(() => _inputEnabled = false);

    // Get rid of any other snackbar still showing.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    _currentSnackBar = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Handle the snackbar's padding interally (see below) to allow for a
        // linear progress indicator to be placed exactly at the top edge.
        padding: EdgeInsets.zero,
        // Give the snackbar a really long duration, so it does not close
        // automatically on its own, but only by the cooldown or the user.
        duration: const Duration(hours: 1),
        // Reset the cooldown animation and start it over once this snackbar is
        // actually shown to the user.
        onVisible: () {
          _cooldown.reset();
          _cooldown.forward();
        },
        content: Listener(
          // Pause the cooldown when the user starts tapping or dragging the
          // snackbar, so they can take as much time as they need to assess.
          onPointerDown: (_) => _cooldown.stop(),
          // Resume the cooldown once the user lets go again.
          onPointerUp: (_) => _cooldown.forward(),
          // Also pass the pointer events down to the snackbar to allow for its
          // standard drag to close behavior.
          behavior: HitTestBehavior.translucent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: snackBarHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedBuilder(
                  animation: _cooldown,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _cooldown.value,
                      // NOTE: This depends on the snackbar's default foreground
                      // color to correctly color this progress indicator, in
                      // case the standard snackbar theme's color is not set.
                      // This could potentially change at some point though,
                      // which would make this the wrong color to use.
                      color: Theme.of(context).snackBarTheme.actionTextColor ??
                          Theme.of(context).colorScheme.inversePrimary,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
                // Mimic the snackbar's default padding internally (allowing the
                // linear progress indicator to be placed exactly at the top
                // edge). See [SnackBar.padding] for a reference of the default
                // padding values.
                // NOTE: This is subject to change as well and could thus
                // potentially deviate from the snackbar's default behavior in
                // the future.
                Padding(
                  padding: const EdgeInsets.only(
                    top: 14.0,
                    bottom: 14.0,
                    left: 24.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          // Show the user whether their answer was correct or
                          // wrong, along with the intended answer in that case.
                          currentQuestion.grade(answer)
                              ? 'Correct!'
                              : 'Wrong! The correct answer is *${currentQuestion.answer}*.',
                        ).formatBold(),
                      ),
                      // Same here, mimic the snackbars default padding.
                      // NOTE: Same issue as above.
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        child: TextButton(
                          onPressed: () => _currentSnackBar?.close(),
                          style: TextButton.styleFrom(
                            // NOTE: Same issue as above.
                            foregroundColor: Theme.of(context)
                                    .snackBarTheme
                                    .actionTextColor ??
                                Theme.of(context).colorScheme.inversePrimary,
                          ),
                          child: const Text('Next →'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Wait for the snackbar to be closed either by the cooldown or by the user.
    await _currentSnackBar?.closed;

    _currentSnackBar = null;

    // Once the snackbar is closed, go to the next question.
    if (mounted) {
      // Reset the cooldown timer.
      _cooldown.reset();

      // Run the handler for when the next question is loaded.
      onNextQuestion?.call();

      setState(() {
        // Enable the text field again for the next question.
        _inputEnabled = true;

        // Actually load the next question.
        _currentQuestion = exercise.nextQuestion();
      });
    }
  }
}

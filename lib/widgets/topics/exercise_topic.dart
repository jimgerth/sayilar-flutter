import 'package:flutter/material.dart';

import 'package:sayilar/extensions/format_bold.dart';
import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/question.dart';
import 'package:sayilar/widgets/topics/topic.dart';

/// A [Topic] for presenting [Exercise]s.
class ExerciseTopic extends Topic {
  /// Create a new [ExerciseTopic].
  const ExerciseTopic({
    super.icon,
    required super.title,
    super.subtitle,
    required this.exercise,
  });

  /// The [Exercise] to be presented by this topic.
  final Exercise exercise;

  @override
  Widget buildBody(BuildContext context) {
    return _ExerciseTopicBody(exercise);
  }
}

/// The body of an [ExerciseTopic] presenting the given [exercise].
class _ExerciseTopicBody extends StatefulWidget {
  /// Create a new [_ExerciseTopicBody].
  const _ExerciseTopicBody(
    this.exercise, {
    // FIXME: Will this parameter ever be used? If not, it could be hard coded.
    // ignore: unused_element
    this.cooldownDuration = const Duration(seconds: 5),
  });

  /// The [Exercise] to be presented in this topic body.
  final Exercise exercise;

  /// How long the latest [Question] remains on screen after being answered.
  ///
  /// After being answered, the latest [Question] will still be shown for this
  /// [Duration] before being replaced by the next [Question]. In that time the
  /// answer can be assessed and reflected upon by the user.
  final Duration cooldownDuration;

  @override
  State<_ExerciseTopicBody> createState() => _ExerciseTopicBodyState();
}

/// The [State] of an [ExerciseTopicBody].
class _ExerciseTopicBodyState extends State<_ExerciseTopicBody>
    with SingleTickerProviderStateMixin {
  /// Shorthand getter for [_ExerciseTopicBody.exercise].
  Exercise get exercise => widget.exercise;

  /// The [Question] currently being shown to the user.
  late Question currentQuestion;

  /// The controller responsible for the input text field.
  TextEditingController inputController = TextEditingController();

  /// Whether the text field is currently enabled for input.
  bool inputEnabled = true;

  /// A handle on a potential [SnackBar] being shown by this widget.
  ScaffoldFeatureController? currentSnackBar;

  /// The cooldown animation active after answering a question.
  ///
  /// See [_ExerciseTopicBody.cooldownDuration] for more information.
  late AnimationController cooldown;

  @override
  void initState() {
    super.initState();

    currentQuestion = exercise.nextQuestion();

    cooldown = AnimationController(
      duration: widget.cooldownDuration,
      vsync: this,
    );

    // Close the snackbar opened by this widget after the cooldown has run out,
    // if it hasn't already been closed before.
    cooldown.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        currentSnackBar?.close();
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();

    // If there is still a snackbar opened by this widget when it is being
    // disposed (e.g. when browsing back) close that snackbar.
    currentSnackBar?.close();

    cooldown.dispose();

    super.dispose();
  }

  /// Check whether the answer put in by the user is correct or not.
  ///
  /// Notify the user about whether the answer they put in was correct or not by
  /// showing a [SnackBar]. After a [cooldown], proceed to the next question.
  void _checkAnswer(String answer) async {
    // Disable the text field for further input during the cooldown.
    setState(() => inputEnabled = false);

    // Get rid of any other snackbar still showing.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    currentSnackBar = ScaffoldMessenger.of(context).showSnackBar(
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
          cooldown.reset();
          cooldown.forward();
        },
        content: Listener(
          // Pause the cooldown when the user starts tapping or dragging the
          // snackbar, so they can take as much time as they need to assess.
          onPointerDown: (_) => cooldown.stop(),
          // Resume the cooldown once the user lets go again.
          onPointerUp: (_) => cooldown.forward(),
          // Also pass the pointer events down to the snackbar to allow for its
          // standard drag to close behavior.
          behavior: HitTestBehavior.translucent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedBuilder(
                  animation: cooldown,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: cooldown.value,
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
                          onPressed: () => currentSnackBar?.close(),
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
    await currentSnackBar?.closed;

    currentSnackBar = null;

    // Once the snackbar is closed, go to the next question.
    if (mounted) {
      // Reset the cooldown timer.
      cooldown.reset();

      // Clear the input text field for the next question.
      inputController.text = '';

      setState(() {
        // Enable the text field again for the next question.
        inputEnabled = true;

        // Actually load the next question.
        currentQuestion = exercise.nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
            ),
            child: Text(
              currentQuestion.question,
              style: Theme.of(context).textTheme.bodyLarge,
            ).formatBold(),
          ),
          TextField(
            enabled: inputEnabled,
            controller: inputController,
            onSubmitted: _checkAnswer,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
              ),
              child: ElevatedButton(
                onPressed: inputEnabled
                    ? () => _checkAnswer(inputController.text)
                    : null,
                child: const Text('Check'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

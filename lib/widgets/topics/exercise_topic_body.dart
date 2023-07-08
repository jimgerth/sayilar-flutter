import 'package:flutter/material.dart' as material show showTimePicker;
import 'package:flutter/material.dart' hide showTimePicker;

import 'package:sayilar/extensions/format_bold.dart';
import 'package:sayilar/extensions/written_out_time.dart';
import 'package:sayilar/model/questions/question.dart';
import 'package:sayilar/widgets/topics/exercise_topic.dart';
import 'package:sayilar/widgets/topics/exercise_topic_body_base.dart';

/// The body of an [ExerciseTopic] presenting the given [exercise].
class ExerciseTopicBody extends ExerciseTopicBodyBase {
  /// Create a new [ExerciseTopicBody].
  const ExerciseTopicBody({
    super.key,
    required super.exercise,
    super.snackBarHeight,
    super.cooldownDuration,
  });

  @override
  State<ExerciseTopicBody> createState() => _ExerciseTopicBodyState();
}

/// The [State] of an [ExerciseTopicBody].
class _ExerciseTopicBodyState
    extends ExerciseTopicBodyBaseState<ExerciseTopicBody> {
  /// The controller responsible for the input text field.
  final TextEditingController inputController = TextEditingController();

  /// The controller responsible for the focus of the input text field.
  final FocusNode inputFocus = FocusNode();

  /// A callback updating if the input is focusable when showing a time picker.
  ///
  /// This shall be registered on the [inputController] and the [inputFocus]
  /// when showing a time picker.
  ///
  /// This will make the input text field not focusable, when it is empty and
  /// not already focused, so that the opening animation of the time picker is
  /// smoother. Otherwise the keyboard would try to open as well at first, just
  /// to close again immediately, which looks janky.
  ///
  /// Note, that this needs to be unregistered again when no time picker should
  /// be shown.
  void _updateInputFocusForTimePicker() {
    inputFocus.canRequestFocus =
        inputFocus.hasFocus || inputController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    if (currentQuestion.showTimePicker) {
      inputFocus.addListener(_updateInputFocusForTimePicker);
      inputController.addListener(_updateInputFocusForTimePicker);
      _updateInputFocusForTimePicker();
    }
  }

  /// A callback to update the state when transitioning to the next question.
  void _onNextQuestion(
    Question currentQuestion,
    Question nextQuestion,
  ) {
    // Clear the input text field for the next question.
    inputController.text = '';

    // Update the listener focus management for the time picker.
    if (!currentQuestion.showTimePicker && nextQuestion.showTimePicker) {
      inputFocus.addListener(_updateInputFocusForTimePicker);
      inputController.addListener(_updateInputFocusForTimePicker);
      _updateInputFocusForTimePicker();
    } else if (currentQuestion.showTimePicker && !nextQuestion.showTimePicker) {
      inputFocus.removeListener(_updateInputFocusForTimePicker);
      inputController.removeListener(_updateInputFocusForTimePicker);
      inputFocus.canRequestFocus = true;
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    inputFocus.dispose();

    super.dispose();
  }

  /// Show a material time picker and potentially update the input text with it.
  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? time = await material.showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: currentQuestion.question.replaceAll('*', ''),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: true,
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      inputController.text = time.asString;
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
            keyboardType: currentQuestion.keyboardType,
            onSubmitted: (answer) => checkAnswer(
              answer,
              _onNextQuestion,
            ),
            style: Theme.of(context).textTheme.bodyLarge,
            focusNode: inputFocus,
            // Hide the keyboard when tapping outside of the text field.
            onTapOutside: (_) => inputFocus.unfocus(),
            onTap: () {
              // Show a time picker when tapping on the text field when it is
              // empty and the currentQuestion calls for it.
              if (currentQuestion.showTimePicker &&
                  inputController.text.isEmpty) {
                _showTimePicker(context);
              }
            },
            decoration: InputDecoration(
              suffixIcon: currentQuestion.showTimePicker
                  ? IconButton(
                      icon: const Icon(Icons.schedule),
                      onPressed: () => _showTimePicker(context),
                    )
                  : null,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
              ),
              child: ElevatedButton(
                onPressed: inputEnabled
                    ? () => checkAnswer(
                          inputController.text,
                          _onNextQuestion,
                        )
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

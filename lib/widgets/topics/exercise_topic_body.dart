import 'package:flutter/material.dart';

import 'package:sayilar/extensions/format_bold.dart';
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
  TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();

    super.dispose();
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
            onSubmitted: (answer) => checkAnswer(
              answer,
              // Clear the input text field for the next question.
              () => inputController.text = '',
            ),
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
                    ? () => checkAnswer(
                          inputController.text,
                          // Clear the input text field for the next question.
                          () => inputController.text = '',
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

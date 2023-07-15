import 'package:flutter/material.dart';

import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/widgets/topics/exercise_topic_body.dart';
import 'package:sayilar/widgets/topics/topic.dart';

/// A [Topic] for presenting [Exercise]s.
class ExerciseTopic extends Topic {
  /// Create a new [ExerciseTopic].
  const ExerciseTopic({
    super.icon,
    required super.title,
    super.subtitle,
    super.onInfoPressed,
    required this.exercise,
  });

  /// The [Exercise] to be presented by this topic.
  final Exercise exercise;

  @override
  Widget buildBody(BuildContext context) {
    return ExerciseTopicBody(
      exercise: exercise,
    );
  }
}

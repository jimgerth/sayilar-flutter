import 'dart:math';

import 'package:sayilar/extensions/random_time.dart';
import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/recognize_time_question.dart';

/// An [Exercise] for [RecognizeTimeQuestion]s.
class RecognizeTimeExercise extends Exercise<RecognizeTimeQuestion> {
  /// Create a new [RecognizeTimeExercise].
  const RecognizeTimeExercise();

  /// A random number generator for generating random times.
  static final Random _random = Random();

  @override
  RecognizeTimeQuestion nextQuestion() {
    return RecognizeTimeQuestion(
      _random.nextTime(),
    );
  }
}

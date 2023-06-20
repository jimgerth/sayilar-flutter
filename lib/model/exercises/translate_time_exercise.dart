import 'dart:math';

import 'package:sayilar/extensions/random_time.dart';
import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/translate_time_question.dart';

/// An [Exercise] for [TranslateTimeQuestion]s.
class TranslateTimeExercise extends Exercise<TranslateTimeQuestion> {
  /// Create a new [TranslateTimeQuestion].
  const TranslateTimeExercise();

  /// A random number generator for generating random times.
  static final Random _random = Random();

  @override
  TranslateTimeQuestion nextQuestion() {
    return TranslateTimeQuestion(
      _random.nextTime(),
    );
  }
}

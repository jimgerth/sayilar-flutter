import 'dart:math';

import 'package:normal/normal.dart';

import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/translate_question.dart';

/// An [Exercise] for [TranslateQuestion]s.
class TranslateExercise extends Exercise<TranslateQuestion> {
  /// Create a new [TranslateQuestion].
  const TranslateExercise();

  @override
  TranslateQuestion nextQuestion() {
    return TranslateQuestion(
      Normal.generate(1, variance: pow(1000, 2))[0].round().abs(),
    );
  }
}

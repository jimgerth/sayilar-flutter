import 'dart:math';

import 'package:normal/normal.dart';

import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/recognize_ordinal_question.dart';

/// An [Exercise] for [RecognizeOrdinalQuestion]s.
class RecognizeOrdinalExercise extends Exercise<RecognizeOrdinalQuestion> {
  /// Create a new [RecognizeOrdinalExercise].
  const RecognizeOrdinalExercise();

  @override
  RecognizeOrdinalQuestion nextQuestion() {
    return RecognizeOrdinalQuestion(
      Normal.generate(1, variance: pow(50, 2))[0].round().abs(),
    );
  }
}

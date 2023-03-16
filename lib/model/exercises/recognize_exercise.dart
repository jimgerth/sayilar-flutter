import 'dart:math';

import 'package:normal/normal.dart';

import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/recognize_question.dart';

/// An [Exercise] for [RecognizeQuestion]s.
class RecognizeExercise extends Exercise<RecognizeQuestion> {
  /// Create a new [RecognizeExercise].
  const RecognizeExercise();

  @override
  RecognizeQuestion nextQuestion() {
    return RecognizeQuestion(
      Normal.generate(1, variance: pow(1000, 2))[0].round().abs(),
    );
  }
}

import 'dart:math';

import 'package:normal/normal.dart';

import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/calculate_question.dart';

/// An [Exercise] for [CalculateQuestion]s.
class CalculateExercise extends Exercise<CalculateQuestion> {
  /// Create a new [CalculateExercise].
  const CalculateExercise();

  @override
  CalculateQuestion nextQuestion() {
    // Get one of the possible mathematical operations for a calculate question.
    final Operation operation = Operation.random;

    // Select a variance for the random numbers based on the operation. In
    // general, the numbers for the more difficult operations (multiplication
    // for example) should be smaller and thus are generated with a smaller
    // variance.
    final num variance = pow(
      () {
        switch (operation) {
          case Operation.addition:
            return 60;
          case Operation.subtraction:
            return 50;
          case Operation.multiplication:
            return 10;
        }
      }(),
      2,
    );

    // Generate the two numbers.
    final int a = Normal.generate(1, variance: variance)[0].round().abs();
    final int b = Normal.generate(1, variance: variance)[0].round().abs();

    // Create the next calculate question.
    return CalculateQuestion(
      // Sort the two numbers from large to small to avoid a negative solution
      // in case of the operation being subtraction.
      max(a, b),
      min(a, b),
      operation,
    );
  }
}
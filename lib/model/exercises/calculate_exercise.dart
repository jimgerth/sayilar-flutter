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
    final num variance;
    final Set<int> avoid;
    switch (operation) {
      case Operation.addition:
        variance = pow(60, 2);
        avoid = {0};
        break;
      case Operation.subtraction:
        variance = pow(50, 2);
        avoid = {0};
        break;
      case Operation.multiplication:
        variance = pow(10, 2);
        avoid = {0, 1};
        break;
    }

    // Generate a random number with the given variance, avoiding some numbers.
    int generate(num variance, [Set<int> avoid = const {}]) {
      int number;
      do {
        number = Normal.generate(1, variance: variance)[0].round().abs();
      } while (avoid.contains(number));
      return number;
    }

    // Generate the two numbers.
    final int a = generate(variance, avoid);
    final int b = generate(variance, avoid);

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

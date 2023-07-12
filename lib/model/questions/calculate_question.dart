import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/translations.dart';

import 'package:sayilar/extensions/written_out.dart';
import 'package:sayilar/model/questions/question.dart';

/// The different possible mathematical operations used in [CalculateQuestion]s.
enum Operation {
  /// The mathematical operation of addition used to add two numbers.
  addition('+'),

  /// The mathematical operation of subtraction used to subtract two numbers.
  subtraction('-'),

  /// The mathematical operation of multiplication used to multiply two numbers.
  multiplication('×');

  /// Create a new [Operation] variant.
  const Operation(this.operation);

  /// The textual sign representing this mathematical operation.
  final String operation;

  /// A random number generator for selecting a random variant.
  static final Random _random = Random();

  @override
  String toString() => operation;

  /// Returns one random mathematical operation from all of the possible ones.
  static Operation get random => values[_random.nextInt(values.length)];

  /// Returns the result of applying this mathematical operation to two numbers.
  int apply(int a, int b) {
    return switch (this) {
      Operation.addition => a + b,
      Operation.subtraction => a - b,
      Operation.multiplication => a * b,
    };
  }
}

/// A [Question] in which a number should be calculated from two other numbers.
///
/// The full length written out names of numbers [a] and [b] will be shown to
/// the user *in turkish* alongside a mathematical [Operation], which they are
/// expected to apply to the numbers and answer with the correct full length
/// written out name of the resulting number.
///
/// For example when asked *"How do you write the answer to bir + iki?"* the
/// correct answer would be *"üç"*.
class CalculateQuestion extends Question {
  /// Create a new [CalculateQuestion].
  const CalculateQuestion(
    this.a,
    this.b,
    this.operation,
  );

  /// The left hand operand in the calculation to be shown to the user.
  final int a;

  /// The right hand operand in the calculation to be shown to the user.
  final int b;

  /// The mathematical [Operation] in the calculation to be shown to the user.
  final Operation operation;

  @override
  String question(BuildContext context) =>
      Translations.of(context).calculateQuestion(
        a.writtenOut,
        operation.toString(),
        b.writtenOut,
      );

  @override
  String get answer => operation.apply(a, b).writtenOut;
}

import 'dart:math';

import 'package:flutter/material.dart';

/// Different difficulty levels for time related questions and exercises.
///
/// Certain times are easier to recognize, translate, etc. than others. For
/// example _3:00_ is _"saat üç"_ whereas _17:22_ is _"saat on yediyi yirmi iki
/// geçiyor"_. The different available difficulty levels are encoded into the
/// variants of this enum.
///
/// To achieve a balanced mix between easier and more difficult times for time
/// related questions and exercises, each difficulty level has an associated
/// [prevalence]. See that for more information on the distribution of the
/// different difficulty levels.
enum TimeDifficulty {
  /// A time with a minute value of 0.
  fullHour(1),

  /// A time with a minute value of 30.
  halfHour(2),

  /// A time with a minute value of 15 or 45.
  quarterHour(4),

  /// A time with a minute value of 10, 20, 40 or 50.
  tenMinutes(8),

  /// A time with any minute value between 0 and 59.
  any(16);

  /// Create a new [TimeDifficulty].
  const TimeDifficulty(this.prevalence);

  /// The probability of getting `this` variant from [random].
  ///
  /// This probability is given as a prevalence score, where the actual
  /// probability of getting `this` variant is `this` variant's score divided by
  /// the sum of all the variants' scores.
  ///
  /// Note that, while [halfHour] explicitly excludes a full hour, [quarterHour]
  /// explicitly excludes a half hour and so on, [any] could still result in a
  /// full, half, etc. hour, which slightly skews the favor in the direction of
  /// such round times being generated in the end.
  ///
  /// The likelyhoods of a random time generated with a [random] variant falling
  /// into each category thus actually are:
  /// - 4.1% full hour
  /// - 7.3% half hour
  /// - 14.6% quarter hour
  /// - 29.2% round ten minutes
  /// - 44.7% any other time
  final int prevalence;

  /// A random number generator for selecting a random variant.
  static final Random _random = Random();

  /// All variants occurring multiple times according to their [prevalence].
  static final List<TimeDifficulty> _choices = values
      .map((value) => List.filled(value.prevalence, value))
      .expand((list) => list)
      .toList();

  /// Returns one random time difficulty from all of the possible ones.
  ///
  /// This takes into account each variant's [prevalence].
  static TimeDifficulty get random =>
      _choices[_random.nextInt(_choices.length)];

  /// Generates a random minute value conforming to `this` difficulty variant.
  int nextMinute() => switch (this) {
        fullHour => 0,
        halfHour => 30,
        quarterHour => _random.nextBool() ? 15 : 45,
        tenMinutes => const [10, 20, 40, 50][_random.nextInt(4)],
        any => _random.nextInt(60)
      };
}

/// An extension to generate random [TimeOfDay]s.
extension RandomTimeOfDay on Random {
  /// Generates a [TimeOfDay].
  ///
  /// This will slightly favor more easily translatable [TimeOfDay]s according
  /// to the different [TimeDifficulty]s and their [TimeDifficulty.prevalence]
  /// distribution.
  TimeOfDay nextTime() {
    return TimeOfDay(
      hour: nextInt(24),
      minute: TimeDifficulty.random.nextMinute(),
    );
  }
}

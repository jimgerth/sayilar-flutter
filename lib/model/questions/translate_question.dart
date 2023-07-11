import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/translations.dart';

import 'package:sayilar/extensions/written_out.dart';
import 'package:sayilar/model/questions/question.dart';

/// A [Question] in which a [number] should be translated by the user.
///
/// The numerical representation of a [number] will be shown to the user and
/// they are expected to answer with the correct full length written out name of
/// that [number] *in turkish*.
///
/// For example when asked *"How do you write 12?"* the correct answer would be
/// *"on iki"*.
class TranslateQuestion extends Question {
  /// Create a new [TranslateQuestion].
  const TranslateQuestion(this.number);

  /// The number to be translated by the user.
  final int number;

  @override
  String question(BuildContext context) =>
      Translations.of(context).translateQuestion(
        number.toString(),
      );

  @override
  String get answer => number.writtenOut;
}

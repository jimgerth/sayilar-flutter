import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/translations.dart';

import 'package:sayilar/extensions/written_out_time.dart';
import 'package:sayilar/model/questions/question.dart';

/// A [Question] in which a [time] should be translated by the user.
///
/// The numerical representation of a [time] will be shown to the user and they
/// are expected to answer with the correct full length written out name of that
/// that [time] *in turkish*.
///
/// For example when asked *"How do you write 13:00?"* the correct answer would
/// be *"saat on üç"*.
class TranslateTimeQuestion extends Question {
  /// Create a new [TranslateTimeQuestion].
  const TranslateTimeQuestion(this.time);

  /// The time to be translated by the user.
  final TimeOfDay time;

  @override
  String question(BuildContext context) =>
      Translations.of(context).translateTimeQuestion(
        time.asString,
      );

  @override
  String get answer => time.writtenOut;

  @override
  List<String> get alternateAnswers => time.alternateWrittenOut;
}

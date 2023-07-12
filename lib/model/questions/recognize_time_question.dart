import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/translations.dart';

import 'package:sayilar/extensions/written_out_time.dart';
import 'package:sayilar/model/questions/question.dart';

/// A [Question] in which a [time] should be recognized by the user.
///
/// The full length written out name of a [time] will be shown to the user *in
/// turkish* and they are expected to answer with the correct numerical value
/// corresponding to that [time].
///
/// For example when asked *"What time is saat on üç?"* the correct answer would
/// be *"13:00"*.
class RecognizeTimeQuestion extends Question {
  /// Create a new [RecognizeTimeQuestion].
  const RecognizeTimeQuestion(this.time);

  /// The time to be recognized by the user.
  final TimeOfDay time;

  @override
  String question(BuildContext context) =>
      Translations.of(context).recognizeTimeQuestion(
        time.writtenOut,
      );

  @override
  String get answer => time.asString;

  @override
  List<String> get alternateAnswers => time.asAlternateStrings;

  @override
  TextInputType get keyboardType => TextInputType.datetime;

  @override
  bool get showTimePicker => true;
}

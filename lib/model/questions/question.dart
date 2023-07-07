import 'package:flutter/material.dart';

import 'package:sayilar/extensions/normalize.dart';

/// An abstract base class for textual questions to be asked the user.
abstract class Question {
  /// Abstract `const` constructor enabling `const` child class constructors.
  const Question();

  /// A formatted string of the question to be shown to the user.
  String get question;

  /// A formatted string of the correct answer the user is expected to put in.
  String get answer;

  /// A list of formatted strings of alternate answers the user can put in too.
  List<String> get alternateAnswers => [];

  /// The [TextInputType] suitable for inputting answers to `this` question.
  ///
  /// Implementing classes can override this to request more specialised
  /// keyboards for inputting answers (e.g. [TextInputType.number] for number
  /// related questions). If left `null`, the system's standard keyboard will be
  /// used.
  TextInputType? get keyboardType => null;

  /// Return whether an [answer] given in response to this question is correct.
  ///
  /// By default, the given [answer] will be deemed correct, if and only if it
  /// is equal to the ideal [Question.answer] or any of the [alternateAnswers]
  /// letter by letter (ignoring casing and whitespace, both leading, trailing
  /// and between the words).
  ///
  /// Implementing classes may override this method in order to customize its
  /// behavior.
  bool grade(String answer) {
    return [
      this.answer.normalize(),
      ...alternateAnswers.map((answer) => answer.normalize()),
    ].contains(answer.normalize());
  }
}

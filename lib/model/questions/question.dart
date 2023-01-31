/// An abstract base class for textual questions to be asked the user.
abstract class Question {
  /// Abstract const constructor enabling const implementing class constructors.
  const Question();

  /// A formatted [String] of the question to be shown to the user.
  String get question;

  /// A formatted [String] of the correct answer the user is expected to put in.
  String get answer;

  /// Return whether an [answer] given in response to this question is correct.
  ///
  /// By default, the given [answer] will be deemed correct, if and only if it
  /// is equal to the ideal [Question.answer] letter by letter (ignoring casing
  /// and leading and trailing white space).
  ///
  /// Implementing classes may override this method in order to customize its
  /// behavior.
  bool grade(String answer) {
    return answer.trim().toLowerCase() == this.answer.trim().toLowerCase();
  }
}

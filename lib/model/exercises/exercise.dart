import 'package:sayilar/model/questions/question.dart';

/// An abstract base class for exercises containing [Question]s for the user.
///
/// Exercises present an infinite stream of the same type of questions to be
/// asked the user via [nextQuestion]. How exactly new questions are selected is
/// up to the specific exercise.
abstract class Exercise<Q extends Question> {
  /// Abstract `const` constructor enabling `const` child class constructors.
  const Exercise();

  /// Return the next question of this exercise.
  Q nextQuestion();
}

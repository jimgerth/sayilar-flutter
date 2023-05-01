import 'package:sayilar/model/exercises/exercise.dart';
import 'package:sayilar/model/questions/question.dart';

/// An exercise for shuffling questions of other different [Exercise]s.
class RandomExercise extends Exercise<Question> {
  /// Create a new [RandomExercise].
  RandomExercise({
    required this.exercises,
  }) : assert(
          exercises.isNotEmpty,
          'At least one Exercise must be given.',
        );

  /// All the available exercises for selecting [Question]s from.
  final List<Exercise> exercises;

  @override
  Question nextQuestion() {
    return (List.from(exercises)..shuffle()).first.nextQuestion();
  }
}

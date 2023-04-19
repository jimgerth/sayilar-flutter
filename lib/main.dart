import 'package:flutter/material.dart';

import 'package:sayilar/model/exercises/calculate_exercise.dart';
import 'package:sayilar/model/exercises/recognize_exercise.dart';
import 'package:sayilar/model/exercises/translate_exercise.dart';
import 'package:sayilar/widgets/topic_selector.dart';
import 'package:sayilar/widgets/topics/exercise_topic.dart';

void main() {
  runApp(const Sayilar());
}

/// The root widget for the Sayılar app.
class Sayilar extends StatelessWidget {
  /// Create a new [Sayilar] widget.
  const Sayilar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sayılar',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sayılar'),
        ),
        body: Center(
          child: TopicSelector(
            topics: const [
              ExerciseTopic(
                icon: Icons.visibility,
                title: 'Recognize',
                subtitle: 'on iki → *12*',
                exercise: RecognizeExercise(),
              ),
              ExerciseTopic(
                icon: Icons.edit,
                title: 'Translate',
                subtitle: '12 → *on iki*',
                exercise: TranslateExercise(),
              ),
              ExerciseTopic(
                icon: Icons.calculate,
                title: 'Calculate',
                subtitle: 'bir + iki = *üç*',
                exercise: CalculateExercise(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

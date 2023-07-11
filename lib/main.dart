import 'package:flutter/material.dart' as material show Brightness;
import 'package:flutter/material.dart' hide Brightness;

import 'package:flutter_gen/gen_l10n/translations.dart';

import 'package:sayilar/model/brightness.dart';
import 'package:sayilar/model/exercises/calculate_exercise.dart';
import 'package:sayilar/model/exercises/random_exercise.dart';
import 'package:sayilar/model/exercises/recognize_exercise.dart';
import 'package:sayilar/model/exercises/recognize_time_exercise.dart';
import 'package:sayilar/model/exercises/translate_exercise.dart';
import 'package:sayilar/model/exercises/translate_time_exercise.dart';
import 'package:sayilar/widgets/topic_selector.dart';
import 'package:sayilar/widgets/topics/directory_topic.dart';
import 'package:sayilar/widgets/topics/exercise_topic.dart';

void main() {
  runApp(const Sayilar());
}

/// The root widget for the Sayılar app.
class Sayilar extends StatefulWidget {
  /// Create a new [Sayilar] widget.
  const Sayilar({super.key});

  @override
  State<Sayilar> createState() => SayilarState();
}

/// The [State] of a [Sayilar] widget.
class SayilarState extends State<Sayilar> {
  /// The [Brightness] to be currently used for the app.
  Brightness brightness = Brightness.first;

  @override
  Widget build(BuildContext context) {
    // The color used to seed the color scheme for the app.
    const Color colorSchemeSeed = Colors.blue;

    return MaterialApp(
      title: 'Sayılar',
      theme: ThemeData(
        colorSchemeSeed: colorSchemeSeed,
        brightness: brightness == Brightness.dark
            ? material.Brightness.dark
            : material.Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: brightness == Brightness.system
          ? ThemeData(
              colorSchemeSeed: colorSchemeSeed,
              brightness: material.Brightness.dark,
              useMaterial3: true,
            )
          : null,
      localizationsDelegates: Translations.localizationsDelegates,
      supportedLocales: Translations.supportedLocales,
      home: Builder(
        // Get a BuildContext, that includes the Translations.
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sayılar'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(brightness.next.icon),
                  tooltip: brightness.next.tooltip,
                  onPressed: () => setState(() => brightness = brightness.next),
                ),
              ],
            ),
            body: Center(
              child: TopicSelector(
                topicGroups: [
                  [
                    DirectoryTopic(
                      icon: Icons.numbers,
                      title: 'Numbers',
                      subtitle: 'Practice numbers',
                      topicGroups: [
                        const [
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
                        [
                          ExerciseTopic(
                            icon: Icons.shuffle,
                            title: 'Random',
                            subtitle: 'All *numbers* exercises!',
                            exercise: RandomExercise(
                              exercises: const [
                                RecognizeExercise(),
                                TranslateExercise(),
                                CalculateExercise(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    DirectoryTopic(
                      icon: Icons.schedule,
                      title: 'Time',
                      subtitle: 'Tell the time',
                      topicGroups: [
                        [
                          const ExerciseTopic(
                            icon: Icons.visibility,
                            title: 'Recognize',
                            subtitle: 'saat on üç → *13:00*',
                            exercise: RecognizeTimeExercise(),
                          ),
                          const ExerciseTopic(
                            icon: Icons.edit,
                            title: 'Translate',
                            subtitle: '13:00 → *saat on üç*',
                            exercise: TranslateTimeExercise(),
                          ),
                        ],
                        [
                          ExerciseTopic(
                            icon: Icons.shuffle,
                            title: 'Random',
                            subtitle: 'All *time* exercises!',
                            exercise: RandomExercise(
                              exercises: const [
                                RecognizeTimeExercise(),
                                TranslateTimeExercise(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  [
                    ExerciseTopic(
                      icon: Icons.shuffle,
                      title: 'Random',
                      subtitle: 'Practice *everything*!',
                      exercise: RandomExercise(
                        exercises: const [
                          RecognizeExercise(),
                          TranslateExercise(),
                          CalculateExercise(),
                          RecognizeTimeExercise(),
                          TranslateTimeExercise(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

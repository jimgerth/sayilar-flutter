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
                  tooltip: brightness.next.tooltip(context),
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
                      title: Translations.of(context).numbersTitle,
                      subtitle: Translations.of(context).numbersSubtitle,
                      topicGroups: [
                        [
                          ExerciseTopic(
                            icon: Icons.visibility,
                            title: Translations.of(context).recognizeTitle,
                            subtitle: 'on iki → *12*',
                            exercise: const RecognizeExercise(),
                          ),
                          ExerciseTopic(
                            icon: Icons.edit,
                            title: Translations.of(context).translateTitle,
                            subtitle: '12 → *on iki*',
                            exercise: const TranslateExercise(),
                          ),
                          ExerciseTopic(
                            icon: Icons.calculate,
                            title: Translations.of(context).calculateTitle,
                            subtitle: 'bir + iki = *üç*',
                            exercise: const CalculateExercise(),
                          ),
                        ],
                        [
                          ExerciseTopic(
                            icon: Icons.shuffle,
                            title: Translations.of(context).randomNumbersTitle,
                            subtitle:
                                Translations.of(context).randomNumbersSubtitle,
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
                      title: Translations.of(context).timeTitle,
                      subtitle: Translations.of(context).timeSubtitle,
                      topicGroups: [
                        [
                          ExerciseTopic(
                            icon: Icons.visibility,
                            title: Translations.of(context).recognizeTimeTitle,
                            subtitle: 'saat on üç → *13:00*',
                            exercise: const RecognizeTimeExercise(),
                          ),
                          ExerciseTopic(
                            icon: Icons.edit,
                            title: Translations.of(context).translateTimeTitle,
                            subtitle: '13:00 → *saat on üç*',
                            exercise: const TranslateTimeExercise(),
                          ),
                        ],
                        [
                          ExerciseTopic(
                            icon: Icons.shuffle,
                            title: Translations.of(context).randomTimeTitle,
                            subtitle:
                                Translations.of(context).randomTimeSubtitle,
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
                      title: Translations.of(context).randomTitle,
                      subtitle: Translations.of(context).randomSubtitle,
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

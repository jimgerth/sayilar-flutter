import 'package:sayilar/extensions/iterable_access.dart';
import 'package:sayilar/model/letters/letters.dart';

/// An extension for transforming words into different *turkish* cases.
extension Cases on String {
  /// Get the list of individual [Letter]s in `this` [String].
  List<Letter> get letters => split('').map(Letter.new).toList();

  /// Transform `this` word into the *turkish* accusative case.
  String get accusative {
    if (isEmpty) {
      return this;
    }

    // Exceptions to the transforming rules.
    if (this == 'üç' || endsWith(' üç')) {
      return '$thisü';
    }

    final Letter lastLetter = letters.last;
    final Vowel? lastVowel = letters.whereType<Vowel>().maybeLast;

    return <Letter>[
      ...letters.withoutLast,
      ...switch (lastLetter) {
        Vowel() => [
            lastLetter,
            VoicedConsonant.y,
          ],
        Consonant() => [
            Letter(lastLetter.mutation ?? lastLetter.character),
          ],
        Letter() => [lastLetter],
      },
      if (lastVowel != null) Letter(lastVowel.fourWayHarmony) else Vowel.i,
    ].join();
  }

  /// Transform `this` word into the *turkish* dative case.
  String get dative {
    if (isEmpty) {
      return this;
    }

    // Exceptions to the transforming rules.
    if (this == 'üç' || endsWith(' üç')) {
      return '${this}e';
    }

    final Letter lastLetter = letters.last;
    final Vowel? lastVowel = letters.whereType<Vowel>().maybeLast;

    return <Letter>[
      ...letters.withoutLast,
      ...switch (lastLetter) {
        Vowel() => [
            lastLetter,
            VoicedConsonant.y,
          ],
        Consonant() => [
            Letter(lastLetter.mutation ?? lastLetter.character),
          ],
        Letter() => [lastLetter],
      },
      if (lastVowel != null) Letter(lastVowel.twoWayHarmony) else Vowel.e,
    ].join();
  }

  /// Add the *turkish* ordinal ending to `this` word.
  String get ordinal {
    if (isEmpty) {
      return this;
    }

    final Letter lastLetter = letters.last;
    final Vowel lastVowel = letters.whereType<Vowel>().maybeLast ?? Vowel.i;

    if (this == 'üç' || endsWith(' üç')) {
        return '$thisüncü';
    }

    return <Letter>[
      ...letters.withoutLast,
      if (lastLetter is Consonant) ...[
        Letter(lastLetter.mutation ?? lastLetter.character),
        Letter(lastVowel.fourWayHarmony)
      ] else lastLetter,
      VoicedConsonant.n,
      VoicedConsonant.c,
      Letter(lastVowel.fourWayHarmony),
    ].join();
  }
}

import 'package:sayilar/model/letters/voiced_consonant.dart';
import 'package:sayilar/model/letters/voiceless_consonant.dart';
import 'package:sayilar/model/letters/vowel.dart';

part 'consonant.dart';

/// A general class for describing letters *in turkish*.
class Letter {
  /// Create a new [Letter] with the given [character].
  ///
  /// The [character] must only contain a single character, so be of length `1`.
  ///
  /// This raw constructor is private, as the unnamed factory [Letter.new]
  /// should be used in favor of this, because it takes into account different
  /// [Letter] subtypes (e.g. [Vowel]s), that contain more information about the
  /// given letter. This constructor is only a fallback wrapper for unknown or
  /// not yet supported characters, such as spaces or punctuation.
  const Letter._(this.character)
      : assert(
          character.length == 1,
          'A Letter can only be created from a single character, but '
          '${character.length} were given.',
        );

  /// Create a new [Letter] from the given [character].
  ///
  /// The [character] must only contain a single character, so be of length `1`.
  ///
  /// This can return any [Letter] subtype (e.g. a [Vowel]), which could contain
  /// more information about the given letter.
  factory Letter(String character) {
    assert(
      character.length == 1,
      'A Letter can only be created from a single character, but '
      '${character.length} were given.',
    );

    return _knownLetters[character] ?? Letter._(character);
  }

  /// All available letters *in turkish*.
  static const List<Letter> values = [
    ...Vowel.values,
    ...Consonant.values,
  ];

  /// A map of all known characters to their respective [Letter]s.
  static final Map<String, Letter> _knownLetters = Map.fromEntries(
    values.map(
      (letter) => MapEntry<String, Letter>(
        letter.character,
        letter,
      ),
    ),
  );

  /// The character represented by `this` [Letter].
  final String character;

  @override
  String toString() => character;
}

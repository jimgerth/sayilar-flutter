// Unfortunately this is needed to access the private super constructor.
part of 'letter.dart';

/// A general class for describing consonants *in turkish*.
abstract class Consonant extends Letter {
  /// Create a new [Consonant].
  ///
  /// Note that [Consonant] is `abstract`, so this cannot be used directly, but
  /// needs to be implemented, because [Letter] is not `abstract`.
  const Consonant._(String character) : super._(character);

  /// The possible mutation of this consonant.
  ///
  /// [VoicedConsonant]s and [VoicelessConsonant]s mutate differently. See
  /// [VoicedConsonant.mutation] and [VoicelessConsonant.mutation] for more
  /// information.
  ///
  /// More information about this topic can be found on the internet (e.g. by
  /// googling _"turkish consonant mutation"_).
  abstract final String? mutation;

  /// All available consonants *in turkish*.
  static const List<Consonant> values = [
    ...VoicedConsonant.values,
    ...VoicelessConsonant.values,
  ];

  @override
  String toString() => character;
}

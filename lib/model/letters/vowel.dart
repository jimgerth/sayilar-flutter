import 'package:sayilar/model/letters/letter.dart';

/// All available vowels *in turkish*.
enum Vowel implements Letter {
  // ignore_for_file: public_member_api_docs
  a('a', 'a', 'ı'),
  e('e', 'e', 'i'),
  i_('ı', 'a', 'ı'),
  i('i', 'e', 'i'),
  o('o', 'a', 'u'),
  o_('ö', 'e', 'ü'),
  u('u', 'a', 'u'),
  u_('ü', 'e', 'ü');

  /// Create a new [Vowel].
  const Vowel(this.character, this.twoWayHarmony, this.fourWayHarmony);

  @override
  final String character;

  /// The vowel, that is in two way harmony with `this` one.
  ///
  /// This can be either `'a'` or `'e'`.
  ///
  /// More information about this topic can be found on the internet (e.g. by
  /// googling _"turkish two way vowel harmony"_).
  final String twoWayHarmony;

  /// The vowel, that is in four way harmony with `this` one.
  ///
  /// This can be one of `'ı'`, `'i'`, `'u'` or `'ü'`.
  ///
  /// More information about this topic can be found on the internet (e.g. by
  /// googling _"turkish four way vowel harmony"_).
  final String fourWayHarmony;

  @override
  String toString() => character;
}

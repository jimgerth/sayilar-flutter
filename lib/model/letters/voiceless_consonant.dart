import 'package:sayilar/model/letters/letter.dart';

/// All available voiceless cosonants *in turkish*.
enum VoicelessConsonant implements Consonant {
  // ignore_for_file: public_member_api_docs
  c_('ç', 'c'),
  f('f'),
  h('h'),
  k('k', 'ğ'),
  p('p', 'b'),
  s('s'),
  s_('ş'),
  t('t', 'd');

  /// Create a new [VoicelessConsonant].
  const VoicelessConsonant(this.character, [this.mutation]);

  @override
  final String character;

  /// The possible mutation of this voiceless consonant.
  ///
  /// When words end in voiceless consonants, some of them ([c_], [k], [p], [t])
  /// mutate to their respective voiced equivalents when an ending starting with
  /// a vowel is appended.
  ///
  /// More information about this topic can be found on the internet (e.g. by
  /// googling _"turkish consonant mutation"_).
  @override
  final String? mutation;

  @override
  String toString() => character;
}

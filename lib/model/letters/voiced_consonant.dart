import 'package:sayilar/model/letters/letter.dart';

/// All available voiced consonants *in turkish*.
enum VoicedConsonant implements Consonant {
  // ignore_for_file: public_member_api_docs
  b('b'),
  c('c', 'ç'),
  d('d', 't'),
  g('g', 'k'),
  g_('ğ'),
  j('j'),
  l('l'),
  m('m'),
  n('n'),
  r('r'),
  v('v'),
  y('y'),
  z('z');

  /// Create a new [VoicedConsonant].
  const VoicedConsonant(this.character, [this.mutation]);

  @override
  final String character;

  /// The possible mutation of this voiced consonant.
  ///
  /// When endings start in voiced consonants, some of them ([c], [d], [g])
  /// mutate to their respective voiceless equivalents when they are appended to
  /// a word ending in a voiceless consonant.
  ///
  /// More information about this topic can be found on the internet (e.g. by
  /// googling _"turkish consonant mutation"_).
  @override
  final String? mutation;

  @override
  String toString() => character;
}

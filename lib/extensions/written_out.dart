import 'package:sayilar/extensions/digits.dart';
import 'package:sayilar/extensions/group.dart';
import 'package:sayilar/extensions/maybe_only.dart';

/// An extension to get the written out name for a number *in turkish*.
extension WrittenOut on int {
  /// The name for the number zero *in turkish*.
  static const String _zero = 'sıfır';

  /// The names of the unit digits `(1-9)` *in turkish*.
  static const List<String> _digits = [
    'bir',
    'iki',
    'üç',
    'dört',
    'beş',
    'altı',
    'yedi',
    'sekiz',
    'dokuz',
  ];

  /// The names of the digit multiples of ten `(10-90)` *in turkish*.
  static const List<String> _tengits = [
    'on',
    'yirmi',
    'otuz',
    'kırk',
    'elli',
    'altmış',
    'yetmiş',
    'seksen',
    'doksan',
  ];

  /// The name for the number hundred *in turkish*.
  static const String _hundred = 'yüz';

  /// The names of the first 5 orders of magnitude `(10^3-10^15)` *in turkish*.
  static const List<String> _ordersOfMagnitude = [
    'bin',
    'milyon',
    'milyar',
    'trilyon',
    'katrilyon',
  ];

  /// Return the words making up the name for a three digit number *in turkish*.
  ///
  /// The three digit number must be passed in as a list of the digits of that
  /// number (a [block]). The list must be of length `3`, with the leading
  /// digits being `0`, if the number is smaller than `100`.
  static List<String> _blockToWords(List<int> block) {
    assert(
      block.length == 3,
      'The passed in block must contain exactly 3 elements.',
    );
    assert(
      block.any(
        (digit) => digit >= 0 && digit <= 9,
      ),
      'Each element in the block must be a digit, i.e. in the range of [0-9].',
    );

    return [
      // The amount of hundreds only needs to be mentioned, when there is more
      // than one (i.e. "hundred ..." is sufficient over "one hundred ...").
      if (block[0] > 1) _digits[block[0] - 1],
      if (block[0] > 0) _hundred,
      if (block[1] > 0) _tengits[block[1] - 1],
      if (block[2] > 0) _digits[block[2] - 1],
    ];
  }

  /// Return the written out name for a number grouped into blocks *in turkish*.
  ///
  /// The number must be passed in as a list of the digits of that number,
  /// grouped into [blocks] (i.e. sublists) of size `3`, starting at the end of
  /// the number. For example `1234` must be `[[0, 0, 1], [2, 3, 4]]`. Notice
  /// that the first block might need to be padded with zeros to be of the right
  /// length.
  static String? _blocksToWord(List<List<int>> blocks) {
    assert(
      blocks.any((block) => block.length == 3),
      'Each block in the passed in blocks must contain exactly 3 elements.',
    );
    assert(
      blocks.any(
        (block) => block.any(
          (digit) => digit >= 0 && digit <= 9,
        ),
      ),
      'Each element in each block must be a digit, i.e. in the range of [0-9].',
    );

    // Get the corresponding words for each block in the given blocks.
    final List<List<String>> blockWords = blocks.map(_blockToWords).toList();

    // If there is only one empty block, the number must be zero.
    if (blockWords.maybeOnly?.isEmpty == true) {
      return _zero;
    }

    // The list of words making up the written out name of the given number to
    // be filled.
    final List<String> words = [];

    try {
      // Reverse the blocks to match their integers up with their corresponding
      // orders of magnitude.
      blockWords.reversed.toList().asMap().forEach(
        (index, block) {
          // If there is some amount of the given order of magnitude present in
          // the number, the name for that order of magnitude needs to be
          // mentioned.
          if (block.isNotEmpty && index >= 1) {
            words.insert(0, _ordersOfMagnitude[index - 1]);
          }

          // As with the hundreds, if there is ony one single unit of a given
          // order of magnitude (i.e. "one thousand ..."), it does not need to
          // be mentioned that it is just one, as that is implied (i.e.
          // "thousand ..." is sufficient). The one exception is the unit
          // "... one", which always needs to be mentioned.
          if (block.maybeOnly != _digits[0] || index == 0) {
            words.insertAll(0, block);
          }
        },
      );
    } on RangeError catch (_) {
      // Catch the error that occurs, when the given number is so big, that
      // there aren't any names for its orders of magnitude anymore.
      return null;
    }

    // Return the now filled words making up the written out name for the given
    // number each separated by a space in a single string.
    return words.join(' ');
  }

  /// Return the full length written out name for this number *in turkish*.
  ///
  /// This ignores the sign of the number.
  String? get writtenOut => _blocksToWord(
        digits.group(
          3,
          start: GroupingStart.end,
          leftoverHandling: const GroupingLeftoverHandling.pad(0),
        ),
      );
}

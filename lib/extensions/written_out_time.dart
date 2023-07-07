import 'package:flutter/material.dart';

import 'package:sayilar/extensions/cases.dart';
import 'package:sayilar/extensions/written_out.dart';

/// An extension to get the written out name for a [TimeOfDay] *in turkish*.
extension WrittenOut on TimeOfDay {
  /// Write out the full length name for `this` [TimeOfDay] *in turkish*.
  ///
  /// Unlike [writtenOut] and [alternateWrittenOut], this includes some options
  /// for writing out the full length name, that are explained in the following.
  ///
  /// When [includeSaat] is `true`, the full length name is prepended with
  /// _"saat"_ (turkish for hour), which is optional in turkish, but often
  /// included in more formal contexts and thus `true` by default.
  ///
  /// When [useVarGeciyor] is `false`, the names for the hour and minute numbers
  /// are simply written out after each other. This is quite informal, as
  /// _"var"_ and _"geçiyor"_ are usually used to indicate the number of minutes
  /// past or to the previous or next hour respectively. Thus this is `true` by
  /// default.
  ///
  /// When [useYarim] is `true`, 0:30 becomes _"(saat) yarım"_ instead of
  /// _"(saat) sıfır buçuk"_ (or _"(saat) sıfır otuz"_ when [useVarGeciyor] is
  /// `false`). This is an irregularity, but is usually done, so this is `true`
  /// by default.
  String writeOut({
    bool includeSaat = true,
    bool useYarim = true,
    bool useVarGeciyor = true,
  }) =>
      [
        if (includeSaat) 'saat ',
        if (minute == 0)
          hour.writtenOut
        else if (useYarim && hour == 0 && minute == 30)
          'yarım'
        else if (useVarGeciyor)
          switch (minute) {
            0 => hour.writtenOut,
            15 => '${hour.writtenOut.accusative} çeyrek geçiyor',
            < 30 =>
              '${hour.writtenOut.accusative} ${minute.writtenOut} geçiyor',
            30 => useYarim && hour == 0 ? 'yarım' : '${hour.writtenOut} buçuk',
            45 => '${((hour + 1) % 24).writtenOut.dative} çeyrek var',
            > 30 =>
              '${((hour + 1) % 24).writtenOut.dative} ${(60 - minute).writtenOut} var',
            _ => throw UnimplementedError(
                'This switch expression is logically exaustive, so this will never '
                'be reached, but is needed to make the compiler happy.',
              ),
          }
        else
          '${hour.writtenOut} ${minute.writtenOut}',
      ].join();

  /// Get the full length written out name for `this` [TimeOfDay] *in turkish*.
  ///
  /// This is the most formal and verbose version of how to write out a number
  /// in turkish, including the leading _"saat"_ and using _"var"/"geçiyor"_.
  String get writtenOut => writeOut();

  /// Get alternate written out names for `this` [TimeOfDay] *in turkish*.
  ///
  /// Alternate versions of how to write out a number in turkish, that shall be
  /// deemed correct too, include omitting the leading _"saat"_, simply writing
  /// out the hour's and minute's numbers instead of using _"var"/"geçiyor"_,
  /// saying _"(saat) sıfır buçuk"_ (turkish for half past zero) or more
  /// informally _"(saat) sıfır otuz"_ (turkish for zero thirty) instead of the
  /// irregular but usual _"(saat) yarım"_ (turkish for half), and any
  /// combination of the above.
  List<String> get alternateWrittenOut => [
        writeOut(
          includeSaat: false,
        ),
        writeOut(
          useVarGeciyor: false,
        ),
        writeOut(
          includeSaat: false,
          useVarGeciyor: false,
        ),
        writeOut(
          useYarim: false,
        ),
        writeOut(
          includeSaat: false,
          useYarim: false,
        ),
        writeOut(
          useYarim: false,
          useVarGeciyor: false,
        ),
        writeOut(
          includeSaat: false,
          useYarim: false,
          useVarGeciyor: false,
        ),
      ];

  /// Return a formatted string representing `this` [TimeOfDay].
  ///
  /// The canonical formatting used for this is "hh:mm", padding the hour with a
  /// leading "0", if its a single digit.
  String get asString => [
        hour.toString().padLeft(2, '0'),
        minute.toString().padLeft(2, '0'),
      ].join(':');

  /// Return some alternative formats of `this` [TimeOfDay] to [asString].
  ///
  /// Alternate formattings, that shall be deemed correct too, include using a
  /// dot (".") as a delimiter instead of a colon (":"), omitting the leading
  /// "0" when the hour is a single digit and omitting the minute when it is a
  /// full hour.
  ///
  /// For example, instead of writing "03:00", it is also acceptable to write
  /// "3:00", "03.00", "3.00", "03" or "3".
  List<String> get asAlternateStrings => [
        [
          hour.toString(),
          minute.toString().padLeft(2, '0'),
        ].join(':'),
        [
          hour.toString().padLeft(2, '0'),
          minute.toString().padLeft(2, '0'),
        ].join('.'),
        [
          hour.toString(),
          minute.toString().padLeft(2, '0'),
        ].join('.'),
        if (minute == 0) hour.toString().padLeft(2, '0'),
        if (minute == 0) hour.toString(),
      ];
}

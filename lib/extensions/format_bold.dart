import 'package:flutter/material.dart';

/// An extension to format text bold based on an indication character.
extension FormatBold on Text {
  /// Return a rich text with the segments in between two [indicator]s in bold.
  ///
  /// An [indicator] character can be escaped with a leading backslash
  /// (represented by two backslashes in a dart [String] literal), e.g.
  /// `"*This* should be bold, but \\* is an asterisc"`.
  Text formatBold({
    String indicator = '*',
  }) {
    // The segments of text split at the indicator character, but stiched back
    // together where the indicator was escaped, to be filled.
    final List<String> escapedSegments = [];

    // Fill the escapedSegments from the back with the segments from the text
    // split at the indicator character.
    for (String segment in data?.split(indicator).reversed ?? []) {
      // If there already was a previous segment (coming after the current
      // segment in the text due to filling from the back) and the current
      // segment ends with a backslash, the indicator between these two segments
      // should be escaped, i.e. inserted back into the final text, and the two
      // segments stiched back together.
      if (escapedSegments.isNotEmpty && segment.endsWith('\\')) {
        escapedSegments.insert(
          0,
          [
            // Remove the backslash used to escape the indicator from the text.
            segment.substring(0, segment.length - 1),
            escapedSegments.removeAt(0),
          ].join(indicator),
        );

        // Otherwise simply copy the current segment into the escapedSegments,
        // as the previous segment does not need to be escaped.
      } else {
        escapedSegments.insert(0, segment);
      }
    }

    // If there was a single unescaped indicator character left over in the
    // text, it should also be escaped, as text should only be formatted bold by
    // two surrounding indicator characters and not by a single unmached one at
    // the end.
    if (escapedSegments.length % 2 == 0) {
      escapedSegments.add(
        [
          escapedSegments.removeAt(escapedSegments.length - 1),
          escapedSegments.removeAt(escapedSegments.length - 1),
        ].reversed.join(indicator),
      );
    }

    return Text.rich(
      // Now, the escapedSegments alternate from needing to be formatted
      // normally and bold. Thus, format this text widget's data using text
      // spans...
      TextSpan(
        children: [
          for (MapEntry<int, String> segment in escapedSegments.asMap().entries)
            TextSpan(
              text: segment.value,
              style: segment.key % 2 == 1
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
        ],
      ),
      // ...and pass on all other parameters to the new Text widget.
      // NOTE: The constructor parameters of Text.rich could be subject to
      // change in the future, so this might need to be updated at some point.
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

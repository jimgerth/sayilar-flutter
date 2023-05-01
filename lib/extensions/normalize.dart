/// An extension for normalizing strings.
extension Normalize on String {
  /// Return the normalized version of this string.
  ///
  /// Normalizing a string includes converting it to all lower case, removing
  /// any leading and trailing whitespace, and replacing any other whitespace
  /// between words with a single space.
  String normalize() {
    return trim().toLowerCase().split(RegExp(r'\s+')).join(' ');
  }
}

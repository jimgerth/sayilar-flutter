/// An extension to maybe get the only element in an iterable.
extension MaybeOnly<T> on Iterable<T> {
  /// Return the only element in an iterable if it is available and alone.
  ///
  /// If there is no element or there are more than one elements, this will
  /// return `null`.
  T? get maybeOnly => length == 1 ? first : null;
}

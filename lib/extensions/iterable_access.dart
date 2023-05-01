/// An extension with shorthands for accessing different pars of [Iterable]s.
extension IterableAccess<T> on Iterable<T> {
  /// Return the only element in `this` [Iterable] if it is available and alone.
  ///
  /// If there is no element or there are more than one elements, this will
  /// return `null`.
  T? get maybeOnly => length == 1 ? first : null;
}

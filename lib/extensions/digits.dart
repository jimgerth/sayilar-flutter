/// An extension to get the individual digits of an integer.
extension Digits on int {
  /// Return a list with the digits of this integer in order.
  ///
  /// This ignores the sign of the integer.
  List<int> get digits {
    // The list of digits to be filled.
    final List<int> digits = [];

    // The number to be decomposed is this number without its sign.
    int number = abs();

    do {
      // Extract the units digit as the remainder after dividing by ten.
      digits.add(number % 10);

      // Shift the number one digit to the right, dropping the previous units
      // digit, that was just added to the digits list.
      number ~/= 10;

      // Do so continually to get all the digits in the number.
    } while (number > 0);

    // Return the now filled list of digits (but reversed, as the list was
    // filled the wrong way round, starting at the last most digit).
    return digits.reversed.toList();
  }
}

import 'package:sayilar/extensions/written_out.dart';
import 'package:sayilar/model/questions/question.dart';

/// A [Question] in which a [number] should be recognized by the user.
///
/// The full length written out name of a [number] will be shown to the user *in
/// turkish* and they are expected to answer with the correct numerical value
/// corresponding to that [number].
///
/// For example when asked *"What number is on iki?"* the correct answer would
/// be *"12"*.
class RecognizeQuestion extends Question {
  /// Create a new [RecognizeQuestion].
  const RecognizeQuestion(this.number);

  /// The number to be recognized by the user.
  final int number;

  @override
  String get question => 'What number is *${number.writtenOut}*?';

  @override
  String get answer => number.toString();
}

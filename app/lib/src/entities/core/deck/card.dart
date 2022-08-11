import 'package:copy_with_extension/copy_with_extension.dart';

part 'card.g.dart';

@CopyWith()
class Card {
  final String id;
  final String? frontText;
  final String? frontImage;
  final String? backText;
  final String? backImage;

  Card({
    required this.id,
    this.frontText,
    this.frontImage,
    this.backText,
    this.backImage,
  });
}

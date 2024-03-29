import 'package:copy_with_extension/copy_with_extension.dart';

part 'card.g.dart';

/// {@category Entidades}
/// Modelo de carta utilizado no core da aplicação
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

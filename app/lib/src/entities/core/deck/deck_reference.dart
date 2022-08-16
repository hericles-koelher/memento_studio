import 'package:copy_with_extension/copy_with_extension.dart';

part 'deck_reference.g.dart';

/// {@category Entidades}
/// Modelo de referência de baralho utilizado no core da aplicação
@CopyWith()
class DeckReference {
  final String id;
  final String? description;
  final String? cover;
  final String name;
  final List<String> tags;
  final String? author;
  final int numberOfCards;

  DeckReference({
    required this.id,
    this.description,
    this.cover,
    required this.name,
    this.tags = const [],
    this.author,
    this.numberOfCards = 0,
  });
}

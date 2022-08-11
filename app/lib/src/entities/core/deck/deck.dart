import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:memento_studio/src/entities.dart';

part 'deck.g.dart';

@CopyWith()
class Deck {
  final String id;
  final List<Card> cards;
  final String? description;
  final String? cover;
  final bool isPublic;
  final DateTime lastModification;
  final String name;
  final List<String> tags;

  Deck({
    required this.id,
    this.cards = const [],
    this.description,
    this.cover,
    this.isPublic = false,
    required this.lastModification,
    required this.name,
    this.tags = const [],
  });
}

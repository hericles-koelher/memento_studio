import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:memento_studio/src/entities.dart';

part 'deck.g.dart';

@CopyWith()
class Deck {
  final String id;
  final List<Card> cards;
  final String? description;
  final String? cover;
  final String name;
  final bool isPublic;
  final List<String> tags;
  final DateTime lastModification;

  Deck({
    required this.id,
    this.cards = const [],
    this.description,
    this.cover,
    required this.name,
    this.isPublic = false,
    this.tags = const [],
    required this.lastModification,
  });
}

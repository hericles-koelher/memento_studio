import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:memento_studio/src/entities.dart';

part 'deck_reference.g.dart';

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
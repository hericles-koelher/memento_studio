import 'package:json_annotation/json_annotation.dart';
import 'package:memento_studio/src/entities/local/deck/deck_reference.dart' as local_model;

part 'deck_reference.g.dart';

@JsonSerializable()
class DeckReference {
  @JsonKey(name: 'UUID')
  final String id;

  @JsonKey(name: 'Description')
  final String description;

  @JsonKey(name: 'Cover')
  final String? cover;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Tags')
  final List<String> tags;

  @JsonKey(name: 'Author')
  final String? author;

  @JsonKey(name: 'NumberOfCards')
  final int numberOfCards;

  DeckReference({
    required this.id,
    this.description = "",
    this.cover = "",
    this.name = "",
    this.tags = const [],
    this.author = "",
    this.numberOfCards = 0,
  });

  factory DeckReference.fromJson(Map<String, dynamic> json) => _$DeckReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$DeckReferenceToJson(this);

  local_model.DeckReference toDomainModel() {
    return local_model.DeckReference(
        id: id, 
        description: description, 
        cover: cover,
        name: name,
        tags: tags,
        numberOfCards: numberOfCards,
        author: author
      );
  }
}
import 'package:json_annotation/json_annotation.dart';
import 'package:memento_studio/src/entities.dart';

part 'api_deck_reference.g.dart';

@JsonSerializable()
class ApiDeckReference {
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

  ApiDeckReference({
    required this.id,
    this.description = "",
    this.cover = "",
    this.name = "",
    this.tags = const [],
    this.author = "",
    this.numberOfCards = 0,
  });

  factory ApiDeckReference.fromJson(Map<String, dynamic> json) =>
      _$ApiDeckReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ApiDeckReferenceToJson(this);

  DeckReference toDomainModel() {
    return DeckReference(
        id: id,
        description: description,
        cover: cover,
        name: name,
        tags: tags,
        numberOfCards: numberOfCards,
        author: author);
  }
}

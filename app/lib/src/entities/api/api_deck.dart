import 'package:json_annotation/json_annotation.dart';
import 'package:memento_studio/src/entities.dart';

part 'api_deck.g.dart';

@JsonSerializable()
class ApiDeck {
  @JsonKey(name: 'UUID')
  final String? id;

  @JsonKey(name: 'cards')
  final List<ApiCard>? cards;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'cover')
  final String? cover;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'isPublic')
  final bool? isPublic;

  @JsonKey(name: 'tags')
  final List<String>? tags;

  @JsonKey(name: 'lastModification')
  final int? lastModification;

  ApiDeck(
      {this.id,
      this.cards,
      this.description,
      this.cover,
      this.name,
      this.isPublic,
      this.tags,
      this.lastModification});

  factory ApiDeck.fromJson(Map<String, dynamic> json) =>
      _$ApiDeckFromJson(json);

  Map<String, dynamic> toJson() => _$ApiDeckToJson(this);
}

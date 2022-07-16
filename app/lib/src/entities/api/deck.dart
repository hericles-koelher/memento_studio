import 'package:json_annotation/json_annotation.dart';
import '../local/deck/deck.dart' as local_deck;
import '../local/deck/card.dart' as local_card;
import 'card.dart';

part 'deck.g.dart';

@JsonSerializable()
class Deck {

  @JsonKey(name: 'UUID')
  final String? id;

  @JsonKey(name: 'cards')
  final List<Card>? cards;

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

  Deck({this.id, this.cards, this.description, this.cover, this.name, this.isPublic, this.tags, this.lastModification});

  factory Deck.fromJson(Map<String, dynamic> json) => _$DeckFromJson(json);

  Map<String, dynamic> toJson() => _$DeckToJson(this);

  local_deck.Deck toDomainModel() {
    return local_deck.Deck(
        id: id!, 
        description: description ?? "", 
        cover: cover,
        name: name ?? "",
        isPublic: isPublic ?? false,
        tags: tags ?? [],
        lastModification: DateTime.fromMicrosecondsSinceEpoch(lastModification ?? 0), // TODO: mudar pro formato correto
        cards: cards?.map((card) => card.toDomainModel()).toList() ?? <local_card.Card>[]
      );
  }
}
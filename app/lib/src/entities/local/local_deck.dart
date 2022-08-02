import 'dart:convert';

import 'package:memento_studio/src/entities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LocalDeck extends LocalDeckBase {
  @Id()
  late int storageId;
  @Transient()
  List<LocalCard>? cards;
  String? cover;
  String? description;
  String id;
  bool isPublic;
  int lastModification;
  String name;
  List<String>? tags;

  List<String>? get dbCards =>
      cards?.map((card) => card.toJson().toString()).toList();

  set dbCards(List<String>? cards) {
    this.cards = cards
        ?.map((card) => LocalCard.fromJson(
              jsonDecode(card),
            ))
        .toList();
  }

  LocalDeck({
    this.storageId = 0,
    this.cards,
    this.cover,
    this.description,
    required this.id,
    required this.isPublic,
    required this.lastModification,
    required this.name,
    this.tags,
  });
}

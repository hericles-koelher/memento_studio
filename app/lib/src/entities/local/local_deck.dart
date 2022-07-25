import 'dart:convert';

import 'package:memento_studio/src/entities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LocalDeck extends LocalDeckBase {
  @Id()
  late int storageId;

  List<LocalCard>? cards;
  String? cover;
  String? description;
  String id;
  bool isPublic;
  int lastModification;
  String name;
  List<String>? tags;

  String? get dbCards => jsonEncode(cards);

  set dbCards(String? cards) {
    if (cards != null) {
      cards = jsonDecode(cards);
    }
  }

  String? get dbTags => jsonEncode(tags);

  set dbTags(String? tags) {
    if (tags != null) {
      tags = jsonDecode(tags);
    }
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

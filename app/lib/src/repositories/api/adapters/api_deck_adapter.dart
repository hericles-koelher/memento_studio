import 'package:memento_studio/src/entities.dart';

class ApiDeckAdapter {
  Deck toCore(ApiDeck deck) {
    return Deck(
        id: deck.id!,
        description: deck.description ?? "",
        cover: deck.cover,
        name: deck.name ?? "",
        isPublic: deck.isPublic ?? false,
        tags: deck.tags ?? [],
        lastModification:
            DateTime.fromMicrosecondsSinceEpoch(deck.lastModification ?? 0),
        cards: deck.cards?.map((card) => card.toDomainModel()).toList() ??
            <Card>[]);
  }

  ApiDeck toApi(Deck deck) {
    return ApiDeck(
      id: deck.id,
      description: deck.description,
      cover: deck.cover,
      name: deck.name,
      isPublic: deck.isPublic,
      tags: deck.tags,
      lastModification: deck.lastModification.millisecondsSinceEpoch,
      cards: deck.cards
          .map((c) =>
              ApiCard(backText: c.backText, frontText: c.frontText, id: c.id))
          .toList(),
    );
  }
}

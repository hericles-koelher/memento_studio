import 'package:memento_studio/src/repositories.dart';

import '../../../entities.dart';

/// {@category Repositórios}
/// Converte baralho do modelo do banco de dados local para o modelo utilizado na aplicação e vice versa.
class ObjectBoxDeckAdapter implements DeckAdapter {
  @override
  Deck toCore(covariant LocalDeck deck) {
    return Deck(
      cards: deck.cards
              ?.map((card) => Card(
                    id: card.id,
                    frontText: card.frontText,
                    frontImage: card.frontImage,
                    backText: card.backText,
                    backImage: card.backImage,
                  ))
              .toList() ??
          [],
      cover: deck.cover,
      description: deck.description,
      id: deck.id,
      isPublic: deck.isPublic,
      lastModification:
          DateTime.fromMillisecondsSinceEpoch(deck.lastModification),
      name: deck.name,
      tags: deck.tags ?? [],
    );
  }

  @override
  LocalDeck toLocal(Deck deck) {
    return LocalDeck(
      cards: deck.cards
          .map((card) => LocalCard(
                id: card.id,
                frontText: card.frontText,
                frontImage: card.frontImage,
                backText: card.backText,
                backImage: card.backImage,
              ))
          .toList(),
      cover: deck.cover,
      description: deck.description,
      id: deck.id,
      isPublic: deck.isPublic,
      lastModification: deck.lastModification.millisecondsSinceEpoch,
      name: deck.name,
      tags: deck.tags,
    );
  }
}

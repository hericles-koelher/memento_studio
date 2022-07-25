import 'dart:typed_data';

import 'package:memento_studio/src/entities.dart';

abstract class DeckRepositoryInterface {
  dynamic getDecks(int page, int pageSize);

  dynamic saveDeck(Deck newDeck, Map<String, Uint8List> images);

  dynamic updateDeck(String id, Map<String, dynamic> deckUpdates,
      Map<String, Uint8List> images);

  dynamic deleteDeck(String id);

  dynamic copyDeck(String id);
}

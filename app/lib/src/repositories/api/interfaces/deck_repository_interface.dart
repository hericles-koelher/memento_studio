import 'dart:typed_data';

import 'package:memento_studio/src/entities.dart';

abstract class DeckRepositoryInterface {
  Future<DeckListResult> getDecks(int page, int pageSize);

  Future<DeckResult> saveDeck(Deck newDeck, Map<String, Uint8List> images);

  Future<DeckResult> updateDeck(String id, Map<String, dynamic> deckUpdates,
      Map<String, Uint8List> images);

  Future<Result> deleteDeck(List<String> ids);

  Future<DeckResult> copyDeck(String id);
}

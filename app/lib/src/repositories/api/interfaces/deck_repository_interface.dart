import 'dart:typed_data';

import 'package:memento_studio/src/entities.dart';

/// {@category Repositórios}
/// Interface do repositório da api de baralho.
abstract class DeckRepositoryInterface {
  Future<DeckListResult> getDecks(int page, int pageSize);

  Future<DeckResult> saveDeck(Deck newDeck, Map<String, Uint8List?> images);

  Future<Result> deleteDeck(List<String> ids);

  Future<DeckResult> copyDeck(String id);
}

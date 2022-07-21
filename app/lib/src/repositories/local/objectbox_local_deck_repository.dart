import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/exceptions.dart';
import 'package:memento_studio/src/repositories/local/local_deck_repository.dart';
import 'package:memento_studio/src/utils.dart';

import '../../../objectbox.g.dart';

class ObjectBoxLocalDeckRepository implements LocalDeckRepository {
  final Box<LocalDeck> _deckBox;

  ObjectBoxLocalDeckRepository()
      : _deckBox = KiwiContainer().resolve<ObjectBox>().store.box();

  @override
  Future<void> create(covariant LocalDeck deck) async {
    if (deck.storageId != 0) {
      throw MSStorageException(
        message: "O deck.storageId deve ser igual a 0",
        code: MSStorageExceptionCode.wrongId,
      );
    } else {
      await _deckBox.putAsync(deck);
    }
  }

  @override
  Future<bool> delete(int storageId) async {
    return _deckBox.remove(storageId);
  }

  @override
  Future<int> findStorageId(String coreId) async {
    var query = _deckBox.query(LocalDeck_.id.equals(coreId)).build();

    var queryResult = query.property(LocalDeck_.storageId).find();

    query.close();

    if (queryResult.isEmpty) {
      throw MSStorageException(
        message: "O deck com deck.id = $coreId não pôde ser encontrado",
        code: MSStorageExceptionCode.deckNotFound,
      );
    } else {
      return queryResult.first;
    }
  }

  @override
  Future<LocalDeckBase> read(int storageId) async {
    var nulableDeck = _deckBox.get(storageId);

    if (nulableDeck == null) {
      throw MSStorageException(
        message:
            "O deck com deck.storageId = $storageId não pôde ser encontrado",
        code: MSStorageExceptionCode.deckNotFound,
      );
    } else {
      return nulableDeck;
    }
  }

  @override
  Future<List<LocalDeck>> readAll(int limit, int offset) async {
    var queryBuilder = _deckBox.query()..order(LocalDeck_.storageId);

    var query = queryBuilder.build()
      ..limit = limit
      ..offset = offset;

    var result = query.find();

    query.close();

    return result;
  }

  @override
  Future<void> update(covariant LocalDeck deck) async {
    if (deck.storageId <= 0) {
      throw MSStorageException(
        message: "O deck.storageId deve ser maior que 0",
        code: MSStorageExceptionCode.wrongId,
      );
    } else if (_deckBox.contains(deck.storageId)) {
      await _deckBox.putAsync(deck);
    } else {
      throw MSStorageException(
        message:
            "O deck com deck.storageId = ${deck.storageId} não pôde ser encontrado",
        code: MSStorageExceptionCode.deckNotFound,
      );
    }
  }
}

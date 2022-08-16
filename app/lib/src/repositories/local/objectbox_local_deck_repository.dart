import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/exceptions.dart';
import 'package:memento_studio/src/repositories/local/local_deck_repository.dart';
import 'package:memento_studio/src/utils.dart';

import '../../../objectbox.g.dart';

/// {@category Repositórios}
/// Repositório de baralhos locais
class ObjectBoxLocalDeckRepository implements LocalDeckRepository {
  final Box<LocalDeck> _deckBox;

  ObjectBoxLocalDeckRepository(ObjectBox objectBox)
      : _deckBox = objectBox.store.box<LocalDeck>();

  /// Salva um novo baralho localmente
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

  /// Retorna a quantidade de baralhos salvos localmente
  @override
  Future<int> count() async => _deckBox.count();

  /// Deleta um baralho salvo localmente
  @override
  Future<bool> delete(int storageId) async {
    return _deckBox.remove(storageId);
  }

  /// Encontra o id do banco de dados de um baralho, dado o id do core da aplicação
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

  /// Lê um baralho salvo localmente
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

  /// Lê todos os baralhos salvos localmente
  @override
  Future<List<LocalDeck>> readAll(int limit, int offset) async {
    Query<LocalDeck> query = (_deckBox.query()
          ..order(
            LocalDeck_.lastModification,
            flags: Order.descending,
          ))
        .build()
      ..limit = limit
      ..offset = offset;

    var result = query.find();

    query.close();

    return result;
  }

  /// Atualiza um baralho salvo
  @override
  Future<void> update(covariant LocalDeck deck) async {
    deck.storageId = await findStorageId(deck.id);

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

  /// Apaga todos os baralhos do usuário salvos localmente
  @override
  Future<void> clear() async {
    _deckBox.removeAll();
  }
}

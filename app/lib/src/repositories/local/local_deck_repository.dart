import 'package:memento_studio/src/entities.dart';

/// {@category Repositórios}
/// Interface do repositório de baralhos locais
abstract class LocalDeckRepository {
  Future<void> create(LocalDeckBase deck);
  Future<int> count();
  Future<bool> delete(int storageId);
  Future<int> findStorageId(String coreId);
  Future<LocalDeckBase> read(int storageId);
  Future<List<LocalDeckBase>> readAll(int limit, int offset);
  Future<void> update(LocalDeckBase deck);
  Future<void> clear();
}

import 'package:memento_studio/src/entities.dart';

abstract class LocalDeckRepository {
  Future<void> create(LocalDeckBase deck);
  Future<bool> delete(int storageId);
  Future<int> findStorageId(String coreId);
  Future<LocalDeckBase> read(int storageId);
  Future<List<LocalDeckBase>> readAll(int limit, int offset);
  Future<void> update(LocalDeckBase deck);
}

abstract class DeletedDeckListRepository {
  Future<void> addId(String id);
  Future<List<String>> readList();
  Future<void> clearList();
}

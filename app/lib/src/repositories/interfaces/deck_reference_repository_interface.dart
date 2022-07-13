abstract class DeckReferenceRepositoryInterface {
  dynamic getDecks(int page, int pageSize, Map<String, dynamic>? filter);
  dynamic getDeck(String id);
}
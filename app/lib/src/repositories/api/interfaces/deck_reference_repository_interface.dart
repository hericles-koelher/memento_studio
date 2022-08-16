/// {@category Repositórios}
/// Interface do repositório da api de referência de baralho.
abstract class DeckReferenceRepositoryInterface {
  dynamic getDecks(int page, int pageSize, {Map<String, dynamic>? filter});
  dynamic getDeck(String id);
}

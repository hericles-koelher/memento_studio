import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/entities.dart';

import 'adapters/api_deck_adapter.dart';
import 'interfaces/deck_reference_repository_interface.dart';

/// {@category Repositórios}
/// Repositório da api de referência de baralho.
class DeckReferenceRepository extends DeckReferenceRepositoryInterface {
  // Serviço do tipo DeckReferenceApi
  DeckReferenceApi api;
  final ApiDeckAdapter _apiAdapter;

  DeckReferenceRepository(this.api) : _apiAdapter = KiwiContainer().resolve();

  /// Lê referências de baralho e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<DeckListReferencesResult> getDecks(int page, int pageSize,
      {Map<String, dynamic>? filter}) async {
    final response = await api.getDecks(pageSize, page, filter);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deckApiList = response.body;
      List<DeckReference> decks =
          deckApiList?.map((deck) => deck.toDomainModel()).toList() ??
              <DeckReference>[];

      return Success(decks);
    }
  }

  /// Lê baralho público e trata resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<DeckResult> getDeck(String id) async {
    final response = await api.getDeck(id);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      if (response.body == null) {
        return Error(Exception("Could not parse response body to deck model"));
      }

      var deck = _apiAdapter.toCore(response.body!);
      return Success(deck);
    }
  }
}

import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/entities.dart';

import 'interfaces/deck_reference_repository_interface.dart';

class DeckReferenceRepository extends DeckReferenceRepositoryInterface {
  DeckReferenceApi api;

  DeckReferenceRepository(this.api);

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

  @override
  Future<DeckResult> getDeck(String id) async {
    final response = await api.getDeck(id);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deck = response.body?.toDomainModel();

      if (deck == null) {
        return Error(Exception("Could not parse response body to deck model"));
      }

      return Success(deck);
    }
  }
}

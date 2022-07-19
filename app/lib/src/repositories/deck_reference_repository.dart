import '../datasource/api/deck_reference_api.dart';
import '../entities/local/result.dart';
import 'interfaces/deck_reference_repository_interface.dart';
import 'package:memento_studio/src/entities/local/deck/deck_reference.dart'
    as local_model;
import 'package:memento_studio/src/entities/local/deck/deck.dart';

typedef DeckListResult = Result<List<local_model.DeckReference>>;
typedef DeckResult = Result<Deck>;

class DeckReferenceRepository extends DeckReferenceRepositoryInterface {
  DeckReferenceApi api;

  DeckReferenceRepository(this.api);

  @override
  Future<DeckListResult> getDecks(int page, int pageSize,
      {Map<String, dynamic>? filter}) async {
    final response = await api.getDecks(pageSize, page, filter);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deckApiList = response.body;
      List<local_model.DeckReference> decks =
          deckApiList?.map((deck) => deck.toDomainModel()).toList() ??
              <local_model.DeckReference>[];

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

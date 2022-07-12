import '../datasource/api/deck_reference_api.dart';
import '../entities/local/result.dart';
import 'interfaces/deck_reference_repository_interface.dart';
import 'package:memento_studio/src/entities/local/result.dart';
import 'package:memento_studio/src/entities/local/deck_reference.dart' as local_model;

typedef DeckListResult = Result<List<local_model.DeckReference>>;

class DeckReferenceRepository extends DeckReferenceRepositoryInterface {
  DeckReferenceApi api;

  DeckReferenceRepository(this.api);

  Future<DeckListResult> getDecks(int page, int pageSize, Map<String, dynamic>? filter) async {
    final response = await api.getDecks(page, pageSize, filter);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deckApiList = response.body;
      List<local_model.DeckReference> decks = deckApiList?.map((deck) => deck.toDomainModel()).toList() ?? <local_model.DeckReference>[];
      
      return Success(decks);
    }
  }

  // Future<DeckResult> getDeck(String id) async {

  // }
}

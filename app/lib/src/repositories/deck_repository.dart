import 'package:memento_studio/src/datasource/api/deck_api.dart';
import 'package:memento_studio/src/repositories/interfaces/deck_repository_interface.dart';
import 'package:memento_studio/src/entities/local/result.dart';
import 'package:memento_studio/src/entities/local/deck.dart' as local_model;

typedef DeckListResult = Result<List<local_model.Deck>>;
typedef DeckResult = Result<local_model.Deck>;

class DeckRepository extends DeckRepositoryInterface{
  final DeckApi _api;

  DeckRepository(this._api);

  @override
  Future<DeckListResult> getDecks(int page, int pageSize) async{
    Map<String, int> pagination = {'page': page, 'limit': pageSize};

    final response = await _api.getDecks(pagination);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deckApiList = response.body;
      List<local_model.Deck> decks = deckApiList?.map((deck) => deck.toDomainModel()).toList() ?? <local_model.Deck>[];
      
      return Success(decks);
    }
  }

  // Future<Response> saveDeck() {
  //   Future<Response> response = _api.postDeck();
  //   return response;
  // }

  // Future<Response> updateDeck() {
  //   Future<Response> response = _api.putDeck();
  //   return response;
  // }

  // Future<Response> deleteDeck() {
  //   Future<Response> response = _api.deleteDeck();
  //   return response;
  // }

  // Future<Response> copyDeck() {
  //   Future<Response> response = _api.copyDeck();
  //   return response;
  // }
}
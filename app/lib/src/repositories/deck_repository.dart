import 'dart:typed_data';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/datasource/api/deck_api.dart';
import 'package:memento_studio/src/repositories/interfaces/deck_repository_interface.dart';
import 'package:memento_studio/src/entities/local/result.dart';
import 'package:memento_studio/src/entities/local/deck.dart' as local_model;
import 'package:memento_studio/src/entities/api/deck.dart' as api_model;
import 'package:memento_studio/src/entities/api/card.dart' as api_model_card;

typedef DeckListResult = Result<List<local_model.Deck>>;
typedef DeckResult = Result<local_model.Deck>;

class DeckRepository extends DeckRepositoryInterface{
  final DeckApi _api;

  DeckRepository(this._api);

  @override
  Future<DeckListResult> getDecks(int page, int pageSize) async {
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

  Future<DeckResult> saveDeck(local_model.Deck newDeck, Map<String, Uint8List> images) async {
    // Adiciona as imagens em uma part para ser enviada na requisicao
    List<PartValueFile> parts = [];
    images.forEach((key, value) { 
      parts.add(PartValueFile(key, value));
    });

    // Converte o baralho pro modelo da api
    final cardsApi = <api_model_card.Card>[];
    newDeck.cards.forEach((c) {
      cardsApi.add(
        api_model_card.Card(
          backText: c.backText,
          frontText: c.frontText,
          id: c.id)
        );
    });

    final newDeckApi = api_model.Deck(
        cards: cardsApi,
        id: newDeck.id,
        description: newDeck.description,
        name: newDeck.name,
        isPublic: newDeck.isPublic,
        tags: newDeck.tags,
        lastModification: newDeck.lastModification.microsecondsSinceEpoch
      );

    // Envia requisição POST
    final response = await _api.postDeck(json.encode(newDeckApi.toJson()), parts);
    
    // Trata resposta
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
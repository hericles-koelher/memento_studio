import 'dart:typed_data';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/entities.dart';

class DeckRepository extends DeckRepositoryInterface {
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
      List<Deck> decks =
          deckApiList?.map((deck) => deck.toDomainModel()).toList() ?? <Deck>[];

      return Success(decks);
    }
  }

  @override
  Future<DeckResult> saveDeck(
      Deck newDeck, Map<String, Uint8List> images) async {
    // Adiciona as imagens em uma part para ser enviada na requisicao
    List<PartValueFile> parts = [];
    images.forEach((key, value) {
      parts.add(PartValueFile(key, value));
    });

    // Converte o baralho pro modelo da api
    final cardsApi = <ApiCard>[];
    for (var c in newDeck.cards) {
      cardsApi
          .add(ApiCard(backText: c.backText, frontText: c.frontText, id: c.id));
    }

    final newDeckApi = ApiDeck(
        cards: cardsApi,
        id: newDeck.id,
        description: newDeck.description,
        name: newDeck.name,
        isPublic: newDeck.isPublic,
        tags: newDeck.tags,
        lastModification: newDeck.lastModification.microsecondsSinceEpoch);

    // Envia requisição POST
    final response =
        await _api.postDeck(json.encode(newDeckApi.toJson()), parts);

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

  @override
  Future<DeckResult> updateDeck(String id, Map<String, dynamic> deckUpdates,
      Map<String, Uint8List> images) async {
    // Adiciona as imagens em uma part para ser enviada na requisicao
    List<PartValueFile> parts = [];
    images.forEach((key, value) {
      parts.add(PartValueFile(key, value));
    });

    // Envia requisição PUT
    final response = await _api.putDeck(id, json.encode(deckUpdates), parts);

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

  @override
  Future<Result> deleteDeck(List<String> ids) async {
    final response = await _api.deleteDeck(ids);

    // Trata resposta
    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      return Success(response.body);
    }
  }

  @override
  Future<DeckResult> copyDeck(String id) async {
    final response = await _api.copyDeck(id);

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
}

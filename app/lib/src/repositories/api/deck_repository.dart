import 'dart:typed_data';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/entities.dart';

import 'adapters/api_deck_adapter.dart';

/// {@category Repositórios}
/// Repositório da api de baralho.
class DeckRepository extends DeckRepositoryInterface {
  final DeckApi _api;
  final ApiDeckAdapter _apiAdapter;

  DeckRepository(this._api) : _apiAdapter = KiwiContainer().resolve();

  /// Lê baralhos de usuário e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<DeckListResult> getDecks(int page, int pageSize) async {
    Map<String, int> pagination = {'page': page, 'limit': pageSize};

    final response = await _api.getDecks(pagination);

    if (!response.isSuccessful) {
      return Error(Exception(response.error.toString()));
    } else {
      final deckApiList = response.body;
      List<Deck> decks =
          deckApiList?.map((deck) => _apiAdapter.toCore(deck)).toList() ??
              <Deck>[];

      return Success(decks);
    }
  }

  /// Salva baralho e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<DeckResult> saveDeck(
      Deck newDeck, Map<String, Uint8List?> images) async {
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
      if (response.body == null) {
        return Error(Exception("Could not parse response body to deck model"));
      }

      var deck = _apiAdapter.toCore(response.body!);
      return Success(deck);
    }
  }

  /// Deleta usuário na api e trata a resposta da api, retornando um [Result]
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

  /// Faz uma cópia de baralho e trata a resposta da api, convertendo para um modelo do core da aplicação, encapsulado em um [Result]
  @override
  Future<DeckResult> copyDeck(String id) async {
    final response = await _api.copyDeck(id);

    // Trata resposta
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

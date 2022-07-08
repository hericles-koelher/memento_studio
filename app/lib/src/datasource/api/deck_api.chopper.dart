// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$DeckApi extends DeckApi {
  _$DeckApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DeckApi;

  @override
  Future<Response<List<Deck>>> getDecks(Map<String, int> pagination) {
    final $url = '/decks';
    final $body = pagination;
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<List<Deck>, Deck>($request);
  }

  @override
  Future<Response<dynamic>> postDeck(Deck deck, dynamic files) {
    final $url = '/decks';
    final $headers = {
      'Content-Type': 'multipart/form-data',
    };

    final $parts = <PartValue>[PartValue<Deck>('deck', deck)];
    $parts.addAll(files);
    final $request = Request('POST', $url, client.baseUrl,
        parts: $parts, multipart: true, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> putDeck(String deckId, Deck deck, dynamic files) {
    final $url = '/decks/${deckId}';
    final $headers = {
      'Content-Type': 'multipart/form-data',
    };

    final $parts = <PartValue>[PartValue<Deck>('deck', deck)];
    $parts.addAll(files);
    final $request = Request('POST', $url, client.baseUrl,
        parts: $parts, multipart: true, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteDeck(String deckId) {
    final $url = '/decks/${deckId}';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> copyDeck(String deckId) {
    final $url = '/decks/${deckId}';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
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
  Future<Response<List<ApiDeck>>> getDecks(Map<String, int> pagination) {
    final $url = '/decks';
    final $body = pagination;
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<List<ApiDeck>, ApiDeck>($request);
  }

  @override
  Future<Response<ApiDeck>> postDeck(
      dynamic deck, List<PartValueFile<dynamic>> images) {
    final $url = '/decks';
    final $headers = {
      'Content-Type': 'multipart/form-data',
    };

    final $parts = <PartValue>[PartValue<dynamic>('deck', deck)];
    $parts.addAll(images);
    final $request = Request('POST', $url, client.baseUrl,
        parts: $parts, multipart: true, headers: $headers);
    return client.send<ApiDeck, ApiDeck>($request);
  }

  @override
  Future<Response<Map<String, dynamic>>> deleteDeck(List<String> decksId) {
    final $url = '/decks';
    final $body = decksId;
    final $request = Request('DELETE', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }

  @override
  Future<Response<ApiDeck>> copyDeck(String deckId) {
    final $url = '/decks/copy/${deckId}';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<ApiDeck, ApiDeck>($request);
  }
}

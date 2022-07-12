// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_reference_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$DeckReferenceApi extends DeckReferenceApi {
  _$DeckReferenceApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DeckReferenceApi;

  @override
  Future<Response<List<DeckReference>>> getDecks(
      int? limit, int? page, Map<String, dynamic>? filter) {
    final $url = '/decksReference';
    final $params = <String, dynamic>{'limit': limit, 'page': page};
    final $body = filter;
    final $request =
        Request('GET', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<List<DeckReference>, DeckReference>($request);
  }
}

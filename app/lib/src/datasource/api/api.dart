import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/utils.dart';
import 'authenticator.dart';
import 'json_converter.dart';
import 'package:memento_studio/src/entities.dart';

/// {@category Comunicação com a API}
/// Classe que cria um cliente [ChopperClient] para comunicação com a API.
class Api {
  /// Define os serviços, os interceptors, o autenticador e os converters de resposta.
  static ChopperClient createInstance() {
    return ChopperClient(
        baseUrl: "$baseUrl/api",
        services: [
          DeckApi.create(),
          UserApi.create(),
          DeckReferenceApi.create()
        ],
        authenticator: MSAuthenticator(),
        interceptors: [HttpLoggingInterceptor(), AuthRequestInterceptor()],
        converter: JsonToTypeConverter({
          ApiDeck: (jsonData) => ApiDeck.fromJson(jsonData),
          ApiUser: (jsonData) => ApiUser.fromJson(jsonData),
          ApiDeckReference: (jsonData) => ApiDeckReference.fromJson(jsonData),
          Map<String, dynamic>: (jsonData) => jsonData
        }));
  }
}

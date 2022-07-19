import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/datasource/api/user_api.dart';
import '../../entities/api/deck_reference.dart';
import '../../entities/api/user.dart';
import 'authenticator.dart';
import 'deck_api.dart';
import 'deck_reference_api.dart';
import 'json_converter.dart';
import 'package:memento_studio/src/entities/api/deck.dart';

class Api {
  static ChopperClient createInstance() {
    return ChopperClient(
        baseUrl: "http://localhost:8080/api",
        services: [
          DeckApi.create(),
          UserApi.create(),
          DeckReferenceApi.create()
        ],
        authenticator: MSAuthenticator(),
        interceptors: [HttpLoggingInterceptor(), AuthRequestInterceptor()],
        converter: JsonToTypeConverter({
          Deck: (jsonData) => Deck.fromJson(jsonData),
          User: (jsonData) => User.fromJson(jsonData),
          DeckReference: (jsonData) => DeckReference.fromJson(jsonData),
          Map<String, dynamic>: (jsonData) => jsonData
        }));
  }
}

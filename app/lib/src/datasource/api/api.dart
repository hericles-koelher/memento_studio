import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/apis.dart';
import 'authenticator.dart';
import 'json_converter.dart';
import 'package:memento_studio/src/entities.dart';

class Api {
  static ChopperClient createInstance() {
    return ChopperClient(
        baseUrl: "https://3274-131-255-21-239.sa.ngrok.io",
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

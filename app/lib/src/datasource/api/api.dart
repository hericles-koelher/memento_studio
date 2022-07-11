import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/datasource/api/user_api.dart';
import '../../entities/api/user.dart';
import 'deck_api.dart';
import 'json_converter.dart';
import 'package:memento_studio/src/entities/api/deck.dart';

class Api {
  static ChopperClient createInstance(){
    return ChopperClient(
      baseUrl: "http://localhost:8080/api",
      services: [
        DeckApi.create(),
        UserApi.create()
        // Colocar os outros (user, referencia) aqui também
      ],
      interceptors: [
        HttpLoggingInterceptor()
      ],
      converter: JsonToTypeConverter({
            Deck: (jsonData) => Deck.fromJson(jsonData),
            User: (jsonData) => User.fromJson(jsonData),
            Map<String, dynamic>: (jsonData) => jsonData
          }
        )
    );
  }
}
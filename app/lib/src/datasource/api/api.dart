import 'package:chopper/chopper.dart';
import 'deck_api.dart';
import 'json_converter.dart';
import 'package:memento_studio/src/entities/api/deck.dart';

class Api {
  static ChopperClient createInstance(){
    return ChopperClient(
      baseUrl: "http://localhost:8080/api",
      services: [
        DeckApi.create()
        // Colocar os outros (user, referencia) aqui também
      ],
      interceptors: [
        HttpLoggingInterceptor()
      ],
      converter: JsonToTypeConverter({
            Deck: (jsonData) => Deck.fromJson(jsonData)
          }
        )
    );
  }
}
import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities.dart';
part 'deck_reference_api.chopper.dart';

typedef DeckReferenceList = List<ApiDeckReference>;

/// {@category Comunicação com a API}
/// Define as requisições que são feitas para a api relacionadas a referências de baralho.
@ChopperApi(baseUrl: "/decksReference")
abstract class DeckReferenceApi extends ChopperService {
  /// Requisição GET de referência de baralhos
  @Get(path: "")
  Future<Response<DeckReferenceList>> getDecks(@Query("limit") int? limit,
      @Query("page") int? page, @Body() Map<String, dynamic>? filter);

  /// Requisição GET de baralho público
  @Get(path: "/{id}")
  Future<Response<ApiDeck>> getDeck(@Path("id") deckId);

  /// Cria uma instância do serviço DeckReferenceApi
  static DeckReferenceApi create([ChopperClient? client]) =>
      _$DeckReferenceApi(client);
}

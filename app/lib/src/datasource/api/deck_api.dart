import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities.dart';
part 'deck_api.chopper.dart';

typedef DeckList = List<ApiDeck>;

/// {@category Comunicação com a API}
/// Define as requisições que são feitas para a api relacionadas a baralhos.
@ChopperApi(baseUrl: "/decks")
abstract class DeckApi extends ChopperService {
  /// Requisição GET de baralhos do usuário em questão.
  @Get(path: "")
  Future<Response<DeckList>> getDecks(@Body() Map<String, int> pagination);

  /// Requisição POST de baralho, que envia um baralho para ser salvo ou atualizado no servidor, junto com suas imagens.
  @Post(path: "", headers: {"Content-Type": "multipart/form-data"})
  @multipart
  Future<Response<ApiDeck>> postDeck(
      @Part("deck") var deck, @PartFileMap() List<PartValueFile> images);

  /// Requisição DELETE de baralho, que remove baralhos do usuário, dado uma lista de ids
  @Delete(path: "")
  Future<Response<Map<String, dynamic>>> deleteDeck(
      @Body() List<String> decksId);

  /// Requisição POST de cópia de baralho, que copia um baralho público para a coleção de baralhos do usuário no servidor.
  @Post(path: "/copy/{id}")
  Future<Response<ApiDeck>> copyDeck(@Path("id") String deckId);

  /// Cria uma instância do serviço DeckApi
  static DeckApi create([ChopperClient? client]) => _$DeckApi(client);
}

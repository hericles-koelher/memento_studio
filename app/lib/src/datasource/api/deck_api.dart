import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities/api/deck.dart';
part 'deck_api.chopper.dart';

typedef DeckList = List<Deck>;

@ChopperApi(baseUrl: "/decks")
abstract class DeckApi extends ChopperService {

  @Get(path: "")
  Future<Response<DeckList>> getDecks(
    @Body() Map<String, int> pagination
  );

  @Post(
    path: "",
    headers: { "Content-Type": "multipart/form-data" })
  @multipart
  Future<Response<Deck>> postDeck(
    @Part("deck") var deck,
    @PartFileMap() var images
  );

  @Put(path: "/{id}",
    headers: { "Content-Type": "multipart/form-data" })
  @multipart
  Future<Response<Deck>> putDeck(
    @Path("id") String deckId,
    @Part("deck") String deckUpdates,
    @PartFileMap() var images,
  );

  @Delete(path: "/{id}")
  Future<Response<Map<String, dynamic>>> deleteDeck(
    @Path("id") String deckId
  );

  @Post(path: "/{id}")
  Future<Response> copyDeck(
    @Path("id") String deckId
  );

  static DeckApi create([ChopperClient? client]) => _$DeckApi(client);
}
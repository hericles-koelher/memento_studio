import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities/api/deck_reference.dart';
import 'package:memento_studio/src/entities/api/deck.dart';
part 'deck_reference_api.chopper.dart';

typedef DeckList = List<DeckReference>;

@ChopperApi(baseUrl: "/decksReference")
abstract class DeckReferenceApi extends ChopperService {

  @Get(path: "")
  Future<Response<DeckList>> getDecks(
    @Query("limit") int? limit,
    @Query("page")  int? page,
    @Body() Map<String, dynamic>? filter
  );

  @Get(path: "/{id}")
  Future<Response<Deck>> getDeck(
    @Path("id") deckId
  );

  static DeckReferenceApi create([ChopperClient? client]) => _$DeckReferenceApi(client);
}
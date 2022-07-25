import 'package:chopper/chopper.dart';
import 'package:memento_studio/src/entities.dart';
part 'deck_reference_api.chopper.dart';

typedef DeckReferenceList = List<ApiDeckReference>;

@ChopperApi(baseUrl: "/decksReference")
abstract class DeckReferenceApi extends ChopperService {
  @Get(path: "")
  Future<Response<DeckReferenceList>> getDecks(@Query("limit") int? limit,
      @Query("page") int? page, @Body() Map<String, dynamic>? filter);

  @Get(path: "/{id}")
  Future<Response<ApiDeck>> getDeck(@Path("id") deckId);

  static DeckReferenceApi create([ChopperClient? client]) =>
      _$DeckReferenceApi(client);
}

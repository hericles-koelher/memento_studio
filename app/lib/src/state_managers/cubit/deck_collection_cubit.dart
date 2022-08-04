import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:meta/meta.dart';

part 'deck_collection_state.dart';

// TODO: Realizar alteração dos baralhos por esse cubit...
class DeckCollectionCubit extends Cubit<DeckCollectionState> {
  final LocalDeckRepository _repository;
  final DeckAdapter _adapter;
  final Logger _logger;

  DeckCollectionCubit(
    LocalDeckRepository repository,
    DeckAdapter adapter,
    Logger logger,
  )   : _repository = repository,
        _adapter = adapter,
        _logger = logger,
        super(InitialDeckCollection());

  Future<void> loadMore(int n) async {
    var localDeckList = await _repository.readAll(n, state.count);

    var coreDeckList = localDeckList.map((e) => _adapter.toCore(e)).toList();

    if (coreDeckList.length + state.count == await _repository.count()) {
      emit(FinalDeckCollection(state.decks + coreDeckList));
      _logger.i("ESTADO FINAL EMITIDO");
    } else {
      emit(ExpansiveDeckCollection(state.decks + coreDeckList));
      _logger.i("ESTADO INTERMÉDIARIO EMITIDO");
    }
  }

  Future<Deck> createDeck({
    required String name,
    String? description,
    required String deckId,
    String? coverPath,
    List<String> tags = const <String>[],
  }) async {
    var deck = Deck(
      name: name,
      description: description,
      lastModification: DateTime.now(),
      id: deckId,
      cover: coverPath,
      tags: tags,
    );

    await _repository.create(_adapter.toLocal(deck));

    var localDeckList = await _repository.readAll(state.count, 0);

    var coreDeckList = localDeckList.map((e) => _adapter.toCore(e)).toList();

    emit(ExpansiveDeckCollection(coreDeckList));

    return deck;
  }

  Future<void> deleteDeck(Deck deck) async {
    int id = await _repository.findStorageId(deck.id);
    await _repository.delete(id);

    var localDeckList = await _repository.readAll(state.count, 0);

    var coreDeckList = localDeckList.map((e) => _adapter.toCore(e)).toList();

    emit(ExpansiveDeckCollection(coreDeckList));
  }
}

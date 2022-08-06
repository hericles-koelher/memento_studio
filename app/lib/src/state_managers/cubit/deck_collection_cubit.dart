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

  Future<void> createDeck(Deck deck) async {
    await _repository.create(_adapter.toLocal(deck));

    _reloadCollection();
  }

  Future<void> _reloadCollection() async {
    var localDeckList = await _repository.readAll(state.count, 0);

    var coreDeckList = localDeckList.map((e) => _adapter.toCore(e)).toList();

    emit(ExpansiveDeckCollection(coreDeckList));
  }

  Future<void> updateDeck(Deck deck) async {
    await _repository.update(_adapter.toLocal(deck));

    await _reloadCollection();
  }

  Future<void> deleteDeck(String id) async {
    int deckStorageId = await _repository.findStorageId(id);

    var result = await _repository.delete(deckStorageId);

    if (result == true) {
      await _reloadCollection();
    }
  }
}

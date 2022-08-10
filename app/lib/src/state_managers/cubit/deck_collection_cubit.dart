import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/repositories/api/adapters/api_deck_adapter.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:meta/meta.dart';

part 'deck_collection_state.dart';

// TODO: Realizar alteração dos baralhos por esse cubit...
class DeckCollectionCubit extends Cubit<DeckCollectionState> {
  final LocalDeckRepository _repository;
  final DeckRepositoryInterface _apiRepo;
  final DeckAdapter _adapter;
  final Logger _logger;
  final ApiDeckAdapter _apiAdapter;
  final DeletedDeckListRepository _deletedDeckListRepository;

  DeckCollectionCubit(
    LocalDeckRepository repository,
    DeckRepositoryInterface apiRepo,
    DeckAdapter adapter,
    Logger logger,
    ApiDeckAdapter apiAdapter,
    DeletedDeckListRepository deletedDeckListRepository,
  )   : _repository = repository,
        _adapter = adapter,
        _logger = logger,
        _apiRepo = apiRepo,
        _apiAdapter = apiAdapter,
        _deletedDeckListRepository = deletedDeckListRepository,
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

    await _reloadCollection();
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

    var deck = await _repository.read(deckStorageId) as LocalDeck;

    if (deck.cover != null && deck.cover!.isNotEmpty) {
      File(deck.cover!).delete();
    }

    deck.cards?.forEach((card) {
      if (card.frontImage != null && card.frontImage!.isNotEmpty) {
        File(card.frontImage!).delete();
      }

      if (card.backImage != null && card.backImage!.isNotEmpty) {
        File(card.backImage!).delete();
      }
    });

    var result = await _repository.delete(deckStorageId);

    if (result == true) {
      await _reloadCollection();
    }
  }

  Future<int> copyDeck(Deck deck) async {
    var localDeck = _adapter.toLocal(deck) as LocalDeck;
    await _repository.create(localDeck);

    var localDeckList = await _repository.readAll(state.count, 0);

    var coreDeckList = localDeckList.map((e) => _adapter.toCore(e)).toList();
    emit(ExpansiveDeckCollection(coreDeckList));

    return localDeck.storageId;
  }

  Future<void> syncDecks() async {
    // Deleta baralhos do servidor que foram deletados localmente
    var deletedDeckList = await _deletedDeckListRepository.readList();

    if (deletedDeckList.isNotEmpty) {
      print("baralhos deletados: ${deletedDeckList.toString()}");
      _apiRepo.deleteDeck(deletedDeckList);
    }

    // Pega baralhos do servidor
    int page = 1, pageSize = 1000000;
    List<Deck> decksFromServer = List.empty();

    final result = await _apiRepo.getDecks(page, pageSize);

    if (result is Error) {
      _logger.e((result as Error).exception.toString());
      return;
    }

    decksFromServer = (result as Success).value;

    // Merge de baralhos
    await mergeDecks(decksFromServer, state.decks);

    // Limpa lista de baralhos deletados
    await _deletedDeckListRepository.clearList();

    _reloadCollection();
  }

  // Aux
  Future<void> mergeDecks(List<Deck> serverDecks, List<Deck> localDecks) async {
    for (Deck lDeck in localDecks) {
      if (lDeck.cover != null && lDeck.cover!.isEmpty) {
        lDeck = lDeck.copyWith(cover: null);
      }

      // Pega ocorrência de baralho do servidor com mesmo id, se tiver
      var result = serverDecks.where((d) => d.id == lDeck.id);
      if (result.isEmpty) {
        _logger.i("Não há ${lDeck.id} no servidor");
        // É um novo baralho, salva no servidor
        var images = await getMapOfImages(lDeck);
        var r = await _apiRepo.saveDeck(lDeck, images);

        if (r is Error) print((r as Error).exception.toString());

        continue;
      }

      // É uma outra versão do baralho local
      var serverVersion = result.first;
      serverDecks.remove(serverVersion);
      _logger.i("Há ${lDeck.id} no servidor- ${serverVersion.cards}");

      // Compara data das versões
      if (lDeck.lastModification.isAfter(serverVersion.lastModification)) {
        _logger.i("Versão local é mais nova");
        // Versão local é mais nova, atualiza no servidor
        var images = await getMapOfImages(lDeck);
        _apiRepo.saveDeck(lDeck, images);
      } else {
        _logger.i("Versão do servidor é mais nova");
        // Versão do servidor é mais nova, atualiza local
        // Remove imagens antigas e baixa imagens do server
        var newLocalDeck =
            await updateLocalDeckGivenRemote(serverVersion, localDeck: lDeck);

        // Salva localmente
        var updatedDeck = _adapter.toLocal(newLocalDeck) as LocalDeck;
        _repository.update(updatedDeck);
      }
    }

    // Salva resto dos baralhos do servidor
    for (Deck rDeck in serverDecks) {
      var newLocalDeck = await updateLocalDeckGivenRemote(rDeck);

      // Salva localmente
      _repository.create(_adapter.toLocal(newLocalDeck));
    }
  }
}

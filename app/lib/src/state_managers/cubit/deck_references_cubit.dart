import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:meta/meta.dart';

part 'deck_references_state.dart';

/// {@category Gerenciamento de estado}
/// Gerenciador de estado de referências de baralhos públicos. Responsável pela reatividade da aplicação.
class DeckReferencesCubit extends Cubit<DeckReferencesState> {
  final DeckReferenceRepositoryInterface _repository;
  final Logger _logger;

  DeckReferencesCubit(
    DeckReferenceRepositoryInterface repository,
    Logger logger,
  )   : _repository = repository,
        _logger = logger,
        super(InitialDeckReferences());

  /// Carrega mais [n] referências de baralho do servidor.
  Future<void> loadMore(int n) async {
    final result =
        await _repository.getDecks(state.page, n, filter: state.filter);

    if (result is Success) {
      final decksRefs = result.value as List<DeckReference>;

      if (decksRefs.length < n) {
        emit(FinalDeckReferences(state.decks + decksRefs, state.page + 1));
        _logger.i("ESTADO FINAL EMITIDO");
      } else {
        emit(ExpansiveDeckReferences(state.decks + decksRefs, state.page + 1));
        _logger.i("ESTADO INTERMÉDIARIO EMITIDO");
      }
    } else {
      emit(ErrorDeckReferences(state.decks, state.page));
      _logger.i("ESTADO DE ERRO EMITIDO");
    }
  }

  /// Atualiza filtro de pesquisa de referências de baralho.
  void setFilter(Map<String, dynamic> filter, int n) {
    emit(ExpansiveDeckReferences(List.empty(), 1, filter: filter));
    _logger.i("ALTERA FILTRO DE PESQUISA EMITIDO");

    loadMore(n);
  }

  /// Reseta estado
  void resetState() {
    emit(InitialDeckReferences());
  }
}

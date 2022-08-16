import 'deck/deck.dart';
import 'deck/deck_reference.dart';

typedef DeckListResult = Result<List<Deck>>;
typedef DeckResult = Result<Deck>;

typedef DeckListReferencesResult = Result<List<DeckReference>>;

/// {@category Entidades}
/// Modelo de resultado de uma requisição da API, utilizado no core da aplicação
abstract class Result<T> {}

/// {@category Entidades}
/// Modelo de resultado de sucesso de uma requisição da API, utilizado no core da aplicação
class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

/// {@category Entidades}
/// Modelo de resultado de erro de uma requisição da API, utilizado no core da aplicação
class Error<T> extends Result<T> {
  final Exception exception;

  Error(this.exception);
}

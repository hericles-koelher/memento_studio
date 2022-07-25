import 'deck/deck.dart';
import 'deck/deck_reference.dart';

typedef DeckListResult = Result<List<Deck>>;
typedef DeckResult = Result<Deck>;

typedef DeckListReferencesResult = Result<List<DeckReference>>;

abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

class Error<T> extends Result<T> {
  final Exception exception;

  Error(this.exception);
}

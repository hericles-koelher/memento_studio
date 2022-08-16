part of 'deck_collection_cubit.dart';

/// {@category Gerenciamento de estado}
/// Estado de baralhos do usuário.
@immutable
abstract class DeckCollectionState {
  final int count;
  final List<Deck> decks;

  const DeckCollectionState(this.decks, this.count);
}

/// {@category Gerenciamento de estado}
class InitialDeckCollection extends DeckCollectionState {
  InitialDeckCollection() : super(List.empty(), 0);
}

/// {@category Gerenciamento de estado}
class ExpansiveDeckCollection extends DeckCollectionState {
  const ExpansiveDeckCollection(List<Deck> decks) : super(decks, decks.length);
}

/// {@category Gerenciamento de estado}
class LoadingDeckCollection extends ExpansiveDeckCollection {
  const LoadingDeckCollection(List<Deck> decks) : super(decks);
}

/// {@category Gerenciamento de estado}
class FinalDeckCollection extends ExpansiveDeckCollection {
  const FinalDeckCollection(List<Deck> decks) : super(decks);
}

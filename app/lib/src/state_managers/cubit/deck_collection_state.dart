part of 'deck_collection_cubit.dart';

@immutable
abstract class DeckCollectionState {
  final int count;
  final List<Deck> decks;

  const DeckCollectionState(this.decks, this.count);
}

class InitialDeckCollection extends DeckCollectionState {
  InitialDeckCollection() : super(List.empty(), 0);
}

class ExpansiveDeckCollection extends DeckCollectionState {
  const ExpansiveDeckCollection(List<Deck> decks) : super(decks, decks.length);
}

class FinalDeckCollection extends ExpansiveDeckCollection {
  const FinalDeckCollection(List<Deck> decks) : super(decks);
}

part of 'deck_references_cubit.dart';

@immutable
abstract class DeckReferencesState {
  final int page;
  final List<DeckReference> decks;
  final Map<String, dynamic>? filter;

  const DeckReferencesState(this.decks, this.page, {this.filter});
}

class InitialDeckReferences extends DeckReferencesState {
  InitialDeckReferences() : super(List.empty(), 1);
}

class ExpansiveDeckReferences extends DeckReferencesState {
  const ExpansiveDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

class FinalDeckReferences extends ExpansiveDeckReferences {
  const FinalDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

class ErrorDeckReferences extends DeckReferencesState {
  const ErrorDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

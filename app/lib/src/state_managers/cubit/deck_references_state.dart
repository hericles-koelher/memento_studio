part of 'deck_references_cubit.dart';

/// {@category Gerenciamento de estado}
/// Estado de referência de baralhos públicos.
@immutable
abstract class DeckReferencesState {
  final int page;
  final List<DeckReference> decks;
  final Map<String, dynamic>? filter;

  const DeckReferencesState(this.decks, this.page, {this.filter});
}

/// {@category Gerenciamento de estado}
class InitialDeckReferences extends DeckReferencesState {
  InitialDeckReferences() : super(List.empty(), 1);
}

/// {@category Gerenciamento de estado}
class ExpansiveDeckReferences extends DeckReferencesState {
  const ExpansiveDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

/// {@category Gerenciamento de estado}
class FinalDeckReferences extends ExpansiveDeckReferences {
  const FinalDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

/// {@category Gerenciamento de estado}
class ErrorDeckReferences extends DeckReferencesState {
  const ErrorDeckReferences(List<DeckReference> decks, int page,
      {Map<String, dynamic>? filter})
      : super(decks, page, filter: filter);
}

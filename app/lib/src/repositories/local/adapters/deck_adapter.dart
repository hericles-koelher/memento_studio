import 'package:memento_studio/src/entities.dart';

/// {@category Repositórios}
/// Adaptador do modelo de dominio pro modelo do banco de dados local
abstract class DeckAdapter {
  Deck toCore(LocalDeckBase deck);
  LocalDeckBase toLocal(Deck deck);
}

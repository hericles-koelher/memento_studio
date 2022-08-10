import 'package:memento_studio/src/entities.dart';

abstract class DeckAdapter {
  Deck toCore(LocalDeckBase deck);
  LocalDeckBase toLocal(Deck deck);
}

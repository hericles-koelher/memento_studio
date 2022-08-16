import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/widgets.dart';

import '../entities.dart' as ms_entities;
import '../state_managers.dart';
import '../utils.dart' as utils;

/// {@category Páginas}
/// Página de gerência de cartas: listagem, edição, inserção e deleção.
class CardListPage extends StatefulWidget {
  final String deckId;

  const CardListPage({Key? key, required this.deckId}) : super(key: key);

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  late final DeckCollectionCubit _collectionCubit;
  late final Logger _logger;

  _CardListPageState() {
    var kiwi = KiwiContainer();

    _collectionCubit = kiwi.resolve();
    _logger = kiwi.resolve();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeckCollectionCubit, DeckCollectionState>(
        bloc: _collectionCubit,
        builder: (context, state) {
          var deck = state.decks.firstWhere(
            (element) => element.id == widget.deckId,
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text("Cartas"),
              centerTitle: true,
            ),
            body: deck.cards.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: utils.horizontalPadding,
                    ),
                    child: Center(
                      child: Text(
                        "Parece que você ainda não tem nenhuma carta...",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  )
                : Scrollbar(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: utils.verticalScrollPadding,
                        horizontal: 15,
                      ),
                      itemCount: deck.cards.length,
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 2),
                      itemBuilder: (context, index) => CardListTile(
                        card: deck.cards[index],
                        onEdit: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Modal(
                              deck: deck,
                              card: deck.cards[index],
                              onDone: (card) {
                                setState(() {
                                  deck.cards[index] = card;

                                  _collectionCubit.updateDeck(
                                    deck.copyWith(
                                        lastModification: DateTime.now()),
                                  );
                                });
                              },
                            ),
                          );
                        },
                        onDelete: () {
                          setState(() {
                            deck.cards.removeAt(index);

                            _collectionCubit.updateDeck(deck.copyWith(
                                lastModification: DateTime.now()));
                          });
                        },
                      ),
                    ),
                  ),
            floatingActionButton: FloatingActionButton(
              child: const FaIcon(FontAwesomeIcons.plus),
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Modal(
                    onDone: (card) {
                      setState(() {
                        deck.cards.add(card);

                        _collectionCubit.updateDeck(
                          deck.copyWith(lastModification: DateTime.now()),
                        );
                      });
                    },
                    deck: deck,
                  ),
                );
              },
            ),
          );
        });
  }
}

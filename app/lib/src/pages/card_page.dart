import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart' as ms_entities;
import '../state_managers.dart';
import '../utils.dart' as utils;

class CardPage extends StatefulWidget {
  final ms_entities.Deck deck;

  const CardPage({Key? key, required this.deck}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late final DeckCollectionCubit _collectionCubit;
  late final Logger _logger;
  late final List<ms_entities.Card> _cardList;

  _CardPageState() {
    var kiwi = KiwiContainer();

    _collectionCubit = kiwi.resolve();
    _logger = kiwi.resolve();
  }

  @override
  void initState() {
    super.initState();
    _cardList = widget.deck.cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartas"),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: utils.verticalScrollPadding,
            horizontal: 15,
          ),
          itemCount: widget.deck.cards.length,
          separatorBuilder: (context, index) => const Divider(thickness: 2),
          itemBuilder: (context, index) => CardListTile(
            card: widget.deck.cards[index],
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
                  deck: widget.deck,
                  card: _cardList[index],
                  onDone: (card) {
                    setState(() {
                      _cardList[index] = card;

                      _collectionCubit.updateDeck(
                        widget.deck.copyWith(
                          cards: _cardList,
                        ),
                      );
                    });
                  },
                ),
              );
            },
            onDelete: () {
              setState(() {
                widget.deck.cards.removeAt(index);

                _collectionCubit.updateDeck(widget.deck);
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
                  _cardList.add(card);

                  _collectionCubit.updateDeck(
                    widget.deck.copyWith(
                      cards: _cardList,
                    ),
                  );
                });
              },
              deck: widget.deck,
            ),
          );
        },
      ),
    );
  }
}

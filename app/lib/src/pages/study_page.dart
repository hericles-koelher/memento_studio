import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;
import 'package:memento_studio/src/state_managers/cubit/deck_collection_cubit.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:memento_studio/src/widgets/card_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

/// {@category Páginas}
/// Página de estudos de um baralho. Exibe as cartas uma de cada vez, virando-a ao toque.
class StudyPage extends StatefulWidget {
  final String deckId;
  final DeckCollectionCubit collectionCubit;

  StudyPage({Key? key, required this.deckId})
      : collectionCubit = KiwiContainer().resolve(),
        super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  var _currentCard = 0;

  late ms_entities.Deck deck;

  @override
  void initState() {
    super.initState();

    deck = widget.collectionCubit.state.decks.firstWhere(
      (element) => element.id == widget.deckId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = 0.70 * MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.name),
        backgroundColor: Colors.transparent,
        shape: const ContinuousRectangleBorder(
          side: BorderSide.none,
        ),
      ),
      body: Column(
        children: [
          header(),
          const Divider(
            thickness: borderWidth,
            color: Colors.black,
          ),
          CarouselSlider(
            options: CarouselOptions(
                height: cardSize,
                enlargeCenterPage: true,
                onPageChanged: (index, _) {
                  setState(() {
                    _currentCard = index;
                  });
                }),
            items: deck.cards.asMap().entries.map((card) {
              return Builder(
                builder: (BuildContext context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FlipCard(
                      fill: Fill
                          .fillBack, // Fill the back side of the card to make in the same size as the front.
                      direction: FlipDirection.HORIZONTAL, // default
                      front: CardView(
                        text: card.value.frontText,
                        imagePath: card.value.frontImage,
                        isFront: true,
                        height: cardSize,
                      ),
                      back: CardView(
                        text: card.value.backText,
                        imagePath: card.value.backImage,
                        isFront: false,
                        height: cardSize,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget header() {
    var horizontalPadding = 25.0;
    var currentPercent = (_currentCard + 1) / deck.cards.length;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${_currentCard + 1}/${deck.cards.length}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 20.0,
                    percent: currentPercent,
                    backgroundColor: Colors.white,
                    progressColor: MSTheme.lightPurple,
                    barRadius: const Radius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

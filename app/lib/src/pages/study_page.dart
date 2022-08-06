import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;
import 'package:memento_studio/src/state_managers/cubit/deck_collection_cubit.dart';
import 'package:memento_studio/src/widgets/card_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StudyPage extends StatefulWidget {
  static final cardsColors = <Color>[
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.deepPurple
  ]; // TODO: Trocar para paleta de cores em outro lugar

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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          const Divider(),
          const Spacer(),
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
                        text: card.value.frontText ?? "",
                        imagePath: card.value.frontImage ?? "",
                        height: cardSize,
                        color: StudyPage.cardsColors[
                            card.key % StudyPage.cardsColors.length],
                      ),
                      back: CardView(
                        text: card.value.backText ?? "",
                        imagePath: card.value.backImage ?? "",
                        height: cardSize,
                        color: StudyPage.cardsColors[
                            card.key % StudyPage.cardsColors.length],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const Spacer()
        ],
      ),
    );
  }

  Widget header() {
    var horizontalPadding = 25.0;
    var currentPercent = _currentCard / (deck.cards.length - 1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deck.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10.0),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 3.5 * horizontalPadding,
            lineHeight: 20.0,
            percent: currentPercent,
            backgroundColor: Colors.grey,
            progressColor: Colors.greenAccent,
            barRadius: const Radius.circular(5.0),
            leading: Text("${_currentCard + 1}/${deck.cards.length}"),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

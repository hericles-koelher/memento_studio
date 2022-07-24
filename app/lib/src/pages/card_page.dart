import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;
import 'package:memento_studio/src/widgets/card_view.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CardPage extends StatefulWidget {
  static final cardsColors = <Color>[
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.deepPurple
  ]; // TODO: Trocar para paleta de cores em outro lugar

  final List<ms_entities.Card> cards;
  final String deckTitle;
  final String deckDescription;
  final bool isPersonalDeck;

  const CardPage(
      {Key? key,
      required this.cards,
      required this.deckTitle,
      required this.deckDescription,
      required this.isPersonalDeck})
      : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  var _currentCard = 0;
  @override
  Widget build(BuildContext context) {
    final cardSize = 0.72 * MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckTitle),
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
            items: widget.cards.asMap().entries.map((card) {
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
                        color: CardPage.cardsColors[
                            card.key % CardPage.cardsColors.length],
                      ),
                      back: CardView(
                        text: card.value.backText ?? "",
                        imagePath: card.value.backImage ?? "",
                        height: cardSize,
                        color: CardPage.cardsColors[
                            card.key % CardPage.cardsColors.length],
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
    var currentPercent = _currentCard / (widget.cards.length - 1);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.deckDescription),
          const SizedBox(height: 10.0),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 3.5 * horizontalPadding,
            lineHeight: 20.0,
            percent: currentPercent,
            backgroundColor: Colors.grey,
            progressColor: Colors.greenAccent,
            barRadius: const Radius.circular(5.0),
            leading: Text("${_currentCard + 1}/${widget.cards.length}"),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

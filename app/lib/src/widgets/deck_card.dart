import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;
import 'package:memento_studio/src/utils.dart';

class DeckCard extends StatelessWidget {
  final ms_entities.Deck deck;
  final double coverDimension;
  final EdgeInsetsGeometry? margin;

  const DeckCard({
    Key? key,
    required this.deck,
    required this.coverDimension,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    bool shouldShowImage = deck.cover != null && deck.cover!.isNotEmpty;

    var coverDecoration = BoxDecoration(
      image: DecorationImage(
        image: (shouldShowImage
                ? Image.memory(
                    File(deck.cover!).readAsBytesSync(),
                  )
                : Image.asset(AssetManager.noImagePath))
            .image,
        fit: BoxFit.cover,
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(borderRadius),
        bottomRight: Radius.circular(borderRadius),
      ),
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: margin,
      child: SizedBox(
        width: coverDimension,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: coverDimension * 0.85,
              width: coverDimension,
              decoration: coverDecoration,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.name,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                  ),
                  Text(
                    "${deck.cards.length} cards",
                    style: textTheme.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

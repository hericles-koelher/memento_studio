import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_studio/src/entities.dart' as ms_entities;

class DeckCard extends StatelessWidget {
  final ms_entities.Deck deck;
  final double coverDimension;
  final Color? defaultCoverColor;
  final EdgeInsetsGeometry? margin;

  DeckCard({
    Key? key,
    required this.deck,
    required this.coverDimension,
    this.margin,
    this.defaultCoverColor,
  })  : assert(
          defaultCoverColor != null ||
              deck.cover != null && deck.cover!.isNotEmpty,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    bool shouldShowImage = deck.cover != null && deck.cover!.isNotEmpty;

    var coverDecoration = BoxDecoration(
      image: shouldShowImage
          ? DecorationImage(
              image: Image.file(File(deck.cover!)).image,
              fit: BoxFit.cover,
            )
          : null,
      color: shouldShowImage ? null : defaultCoverColor,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: margin,
      child: SizedBox(
        width: coverDimension,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: coverDimension,
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
                  ),
                  if (deck.description != null)
                    Text(
                      deck.description!,
                      style: textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${deck.cards.length} cards",
                      style: textTheme.caption,
                    ),
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

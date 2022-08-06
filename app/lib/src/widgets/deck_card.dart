import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

    dynamic imageCover = getDeckCover();

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: margin,
      child: SizedBox(
        width: coverDimension,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageCover,
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

  Widget getDeckCover() {
    bool shouldShowImage = deck.cover != null && deck.cover!.isNotEmpty;
    var imageHeight = coverDimension * 0.89;

    var placeholderImage = const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(AssetManager.noImagePath),
        fit: BoxFit.cover,
      ),
    );

    if (shouldShowImage && !deck.cover!.contains('http')) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(deck.cover!)),
            fit: BoxFit.cover,
          ),
        ),
        height: imageHeight,
        width: coverDimension,
      );
    } else if (!shouldShowImage) {
      return Container(
        decoration: placeholderImage,
        height: imageHeight,
        width: coverDimension,
      );
    }

    return CachedNetworkImage(
      fit: BoxFit.cover,
      height: imageHeight,
      width: coverDimension,
      imageUrl: deck.cover ?? "",
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        decoration: placeholderImage,
      ),
    );
  }
}

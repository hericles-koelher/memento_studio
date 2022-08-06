import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/utils.dart';

Future<Map<String, Uint8List>> getMapOfImages(Deck deck) async {
  Map<String, Uint8List> images = <String, Uint8List>{};

  if (deck.cover != null) {
    images["deck-image"] = await getImageFromLocalPath(deck.cover!);
  }

  for (Card card in deck.cards) {
    if (card.frontImage != null) {
      images["card-front-${card.id}"] =
          await getImageFromLocalPath(card.frontImage!);
    }

    if (card.backImage != null) {
      images["card-back-${card.id}"] =
          await getImageFromLocalPath(card.backImage!);
    }
  }

  return images;
}

Future<Deck> updateLocalDeckGivenRemote(Deck deck, {Deck? localDeck}) async {
  Deck newDeck = deck.copyWith();

  // Deleta imagens locais
  if (localDeck != null) {
    deleteLocalImage(localDeck.cover);
    for (Card card in localDeck.cards) {
      deleteLocalImage(card.backImage);
      deleteLocalImage(card.backImage);
    }
  }

  String coverPath = "";
  if (deck.cover != null) {
    var imageBytes = await getImageFromWebPath(deck.cover!);

    coverPath = await storeDeckCoverImageIntoAppFolder(
      image: MemoryImage(extension: ".jpg", bytes: imageBytes),
      deckId: deck.id,
    );
  }
  newDeck = deck.copyWith(cover: coverPath);

  List<Card> newCards = List.empty(growable: true);
  for (Card card in deck.cards) {
    String frontPath = "", backPath = "";

    if (card.frontImage != null) {
      var imageBytes = await getImageFromWebPath(card.frontImage!);

      frontPath = await storeCardImageIntoAppFolder(
        isFront: true,
        image: MemoryImage(extension: ".jpg", bytes: imageBytes),
        deckId: deck.id,
        cardId: card.id,
      );
    }

    if (card.backImage != null) {
      var imageBytes = await getImageFromWebPath(card.backImage!);

      backPath = await storeCardImageIntoAppFolder(
        isFront: true,
        image: MemoryImage(extension: ".jpg", bytes: imageBytes),
        deckId: deck.id,
        cardId: card.id,
      );
    }

    newCards.add(card.copyWith(frontImage: frontPath, backImage: backPath));
  }

  return newDeck.copyWith(cards: newCards);
}

Future<Uint8List> getImageFromLocalPath(String? path) async {
  try {
    var bytes = await io.File(path!).readAsBytes();
    return bytes;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}

Future<Uint8List> getImageFromWebPath(String path) async {
  try {
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse(path)).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    return bytes;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}

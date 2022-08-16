import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/utils.dart';

/// {@category Utils}
/// Dado um baralho com caminhos de imagem local, retorna um mapa com os bytes de cada imagem.
Future<Map<String, Uint8List?>> getMapOfImages(Deck deck) async {
  Map<String, Uint8List?> images = <String, Uint8List?>{};

  if (deck.cover != null && deck.cover!.isNotEmpty) {
    images["deck-image"] = await getImageFromLocalPath(deck.cover!);
  } else {
    images["deck-image"] = null;
  }

  for (Card card in deck.cards) {
    if (card.frontImage != null && card.frontImage!.isNotEmpty) {
      images["card-front-${card.id}"] =
          await getImageFromLocalPath(card.frontImage!);
    } else {
      images["card-front-${card.id}"] = null;
    }

    if (card.backImage != null && card.backImage!.isNotEmpty) {
      images["card-back-${card.id}"] =
          await getImageFromLocalPath(card.backImage!);
    } else {
      images["card-back-${card.id}"] = null;
    }
  }

  return images;
}

/// {@category Utils}
/// Dado um baralho com caminhos de imagem na web, baixa imagem e salva localmente, retornando
/// um baralho com caminhos de imagem local. Se for uma atualização de um baralho que já existe,
/// deve-se passar o baralho local também.
Future<Deck> updateLocalDeckGivenRemote(Deck deck, {Deck? localDeck}) async {
  Deck newDeck = deck.copyWith();

  // Deleta imagens locais
  if (localDeck != null) {
    deleteLocalImage(localDeck.cover);
    for (Card card in localDeck.cards) {
      deleteLocalImage(card.frontImage);
      deleteLocalImage(card.backImage);
    }
  }

  String coverPath = "";
  if (deck.cover != null && deck.cover!.isNotEmpty) {
    var imageBytes = await getImageFromWebPath(deck.cover!);

    if (imageBytes.isNotEmpty) {
      coverPath = await storeDeckCoverImageIntoAppFolder(
        image: MemoryImage(extension: "jpg", bytes: imageBytes),
        deckId: deck.id,
      );
    }
  }
  newDeck = deck.copyWith(cover: coverPath);

  List<Card> newCards = List.from(deck.cards);

  for (int i = 0; i < newCards.length; i++) {
    String frontPath = "", backPath = "";

    if (newCards[i].frontImage != null && newCards[i].frontImage!.isNotEmpty) {
      var imageBytes = await getImageFromWebPath(newCards[i].frontImage!);

      if (imageBytes.isEmpty) continue;

      frontPath = await storeCardImageIntoAppFolder(
        isFront: true,
        image: MemoryImage(extension: "jpg", bytes: imageBytes),
        deckId: deck.id,
        cardId: newCards[i].id,
      );
    }

    if (newCards[i].backImage != null && newCards[i].backImage!.isNotEmpty) {
      var imageBytes = await getImageFromWebPath(newCards[i].backImage!);

      if (imageBytes.isEmpty) continue;

      backPath = await storeCardImageIntoAppFolder(
        isFront: false,
        image: MemoryImage(extension: "jpg", bytes: imageBytes),
        deckId: deck.id,
        cardId: newCards[i].id,
      );
    }
    newCards[i] =
        newCards[i].copyWith(frontImage: frontPath, backImage: backPath);
    ;
  }

  return newDeck.copyWith(cards: newCards);
}

/// {@category Utils}
/// Pega bytes de imagem salva localmente
Future<Uint8List> getImageFromLocalPath(String? path) async {
  try {
    var bytes = await io.File(path!).readAsBytes();
    return bytes;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}

/// {@category Utils}
/// Pega bytes de imagem da internet
Future<Uint8List> getImageFromWebPath(String path) async {
  try {
    final ByteData imageData =
        await NetworkAssetBundle(Uri.parse("$baseUrl/$path")).load("");
    final Uint8List bytes = imageData.buffer.asUint8List();
    return bytes;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}

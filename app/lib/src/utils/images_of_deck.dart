import 'dart:typed_data';
import 'dart:io' as io;

import 'package:memento_studio/src/entities.dart';

Future<Map<String, Uint8List>> getMapOfImages(Deck deck) async {
  Map<String, Uint8List> images = <String, Uint8List>{};

  if (deck.cover != null && !deck.cover!.contains("http")) {
    images["deck-image"] = await getImageFromPath(deck.cover!);
  }

  for (Card card in deck.cards) {
    if (card.frontImage != null && !card.frontImage!.contains("http")) {
      images["card-front-${card.id}"] =
          await getImageFromPath(card.frontImage!);
    }

    if (card.backImage != null && !card.backImage!.contains("http")) {
      images["card-back-${card.id}"] = await getImageFromPath(card.backImage!);
    }
  }

  return images;
}

Future<Uint8List> getImageFromPath(String? path) async {
  try {
    var bytes = await io.File(path!).readAsBytes();
    return bytes;
  } catch (e) {
    return Uint8List.fromList([]);
  }
}

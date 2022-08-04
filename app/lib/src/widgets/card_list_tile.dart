import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_studio/src/utils.dart';
import '../entities.dart' as ms_entities;

class CardListTile extends StatelessWidget {
  final ms_entities.Card _card;
  final VoidCallback _onTap;

  const CardListTile({
    Key? key,
    required ms_entities.Card card,
    required VoidCallback onTap,
  })  : _card = card,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Image img;

    if (_card.frontImage != null) {
      img = Image.file(File(_card.frontImage!));
    } else {
      img = Image.asset(AssetManager.noImagePath);
    }

    return ListTile(
      onTap: _onTap,
      leading: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(image: img.image),
        ),
      ),
      title: Text(
        _card.frontText ?? "Card sem pergunta...",
      ),
    );
  }
}

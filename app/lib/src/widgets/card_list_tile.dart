import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memento_studio/src/utils.dart';
import '../entities.dart' as ms_entities;

class CardListTile extends StatelessWidget {
  final ms_entities.Card _card;
  final VoidCallback _onEdit;
  final VoidCallback _onDelete;

  const CardListTile({
    Key? key,
    required ms_entities.Card card,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  })  : _card = card,
        _onEdit = onEdit,
        _onDelete = onDelete,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      leading: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: img.image,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      title: Text(
        _card.frontText ?? "Card sem pergunta...",
        overflow: TextOverflow.ellipsis,
      ),
      trailing: PopupMenuButton<int>(
        itemBuilder: (_) => [
          const PopupMenuItem<int>(
            value: 1,
            child: Text("Editar"),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text("Deletar"),
          ),
        ],
        onSelected: (value) {
          if (value == 1) {
            _onEdit();
          } else {
            _onDelete();
          }
        },
      ),
    );
  }
}

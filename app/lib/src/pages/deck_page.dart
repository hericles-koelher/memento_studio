// ignore_for_file: unnecessary_const

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memento_studio/src/entities.dart';

import 'card_page.dart';

class DeckPage extends StatefulWidget {
  final Deck deck;
  final bool isPersonalDeck;

  const DeckPage({Key? key, required this.deck, required this.isPersonalDeck})
      : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    var tags = widget.deck.tags.isNotEmpty ? widget.deck.tags : ["Sem Tags"];

    dynamic imageCover = getDeckCover();

    var popUpMenu = PopupMenuButton(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
      return widget.isPersonalDeck
          ? [
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Editar"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text(
                  "Deletar",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ]
          : [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Fazer uma cópia"),
              )
            ];
    }, onSelected: (value) {
      switch (value) {
        case 0:
          // TODO: Fazer cópia de baralho
          print("Faz cópia de baralho");
          break;
        case 1:
          // TODO: Ir pra tela de edição de baralho
          print("Editar baralho");
          break;
        case 2:
          // TODO: Deletar baralho
          print("Deletar baralho");
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [popUpMenu],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            imageCover,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.deck.name,
                    style: const TextStyle(fontSize: 32.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.deck.description ?? "",
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: -10.0,
                    children: [for (var tag in tags) Chip(label: Text(tag))],
                  ),
                  const SizedBox(height: 5.0),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Por Fulano de tal",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${widget.deck.cards.length} cartas",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      widget.deck.cards.shuffle();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardPage(
                              deckTitle: widget.deck.name,
                              deckDescription: widget.deck.description ?? "",
                              cards: widget.deck.cards,
                              isPersonalDeck: widget.isPersonalDeck),
                        ),
                      );
                    },
                    child: const Text('Começar'),
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
    bool shouldShowImage =
        widget.deck.cover != null && widget.deck.cover!.isNotEmpty;
    var imageHeight = 300.0;

    var placeholderImage = const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.cover,
      ),
    );

    if (shouldShowImage && !widget.deck.cover!.contains('http')) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.deck.cover!),
            fit: BoxFit.cover,
          ),
        ),
        height: imageHeight,
      );
    } else if (!shouldShowImage) {
      return Container(
        decoration: placeholderImage,
        height: imageHeight,
      );
    }

    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width,
      height: imageHeight,
      imageUrl: widget.deck.cover ?? "",
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        decoration: placeholderImage,
      ),
    );
  }
}

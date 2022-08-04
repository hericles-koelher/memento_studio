import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart' as ms_entities;
import '../state_managers.dart';
import '../utils.dart' as utils;

class CardPage extends StatefulWidget {
  final ms_entities.Deck deck;

  const CardPage({Key? key, required this.deck}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late final DeckCollectionCubit _collectionCubit;
  late final Logger _logger;
  late final List<ms_entities.Card> _cardList;

  final _frontText = TextEditingController();
  final _backText = TextEditingController();

  utils.MemoryImage? _front;
  utils.MemoryImage? _back;

  _CardPageState() {
    var kiwi = KiwiContainer();

    _collectionCubit = kiwi.resolve();
    _logger = kiwi.resolve();
  }

  @override
  void initState() {
    super.initState();
    _cardList = widget.deck.cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cartas"),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: utils.horizontalPadding,
          ),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: utils.verticalScrollPadding,
            ),
            itemCount: widget.deck.cards.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => CardListTile(
              card: _cardList[index],
              onTap: () {},
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const FaIcon(FontAwesomeIcons.plus),
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            context: context,
            isScrollControlled: true,
            builder: (context) => WillPopScope(
              onWillPop: () async {
                _front = _back = null;

                _frontText.clear();
                _backText.clear();

                return true;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: utils.horizontalPadding,
                  vertical: utils.verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              minLines: null,
                              maxLength:
                                  utils.Validator.cardQuestionOrAnswerMaxLength,
                              controller: _frontText,
                              decoration: const InputDecoration(
                                labelText: "Frente",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            utils.borderRadius),
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text("Galeria"),
                                            onTap: () async {
                                              var memImg = await utils
                                                  .getImageFromDevice(
                                                      fromGallery: true);

                                              if (memImg != null) {
                                                setState(() {
                                                  _front = memImg;
                                                });
                                              }

                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: const Text("Câmera"),
                                            onTap: () async {
                                              var memImg = await utils
                                                  .getImageFromDevice(
                                                      fromGallery: false);

                                              if (memImg != null) {
                                                setState(() {
                                                  _front = memImg;
                                                });
                                              }

                                              Navigator.pop(context);
                                            },
                                          ),
                                          if (_front != null)
                                            ListTile(
                                              title:
                                                  const Text("Remover imagem"),
                                              onTap: () async {
                                                setState(() {
                                                  _front = null;
                                                });

                                                Navigator.pop(context);
                                              },
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _front != null
                                        ? Image.memory(_front!.bytes).image
                                        : Image.asset(
                                                utils.AssetManager.noImagePath)
                                            .image,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: SizedBox(
                                  height: 65,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.black.withOpacity(0.25),
                                      ),
                                      const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: Colors.white,
                                          size: utils.iconButtonSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              minLines: null,
                              maxLength:
                                  utils.Validator.cardQuestionOrAnswerMaxLength,
                              controller: _backText,
                              decoration: const InputDecoration(
                                labelText: "Verso",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            utils.borderRadius),
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: const Text("Galeria"),
                                            onTap: () async {
                                              var memImg = await utils
                                                  .getImageFromDevice(
                                                      fromGallery: true);

                                              if (memImg != null) {
                                                setState(() {
                                                  _back = memImg;
                                                });
                                              }

                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: const Text("Câmera"),
                                            onTap: () async {
                                              var memImg = await utils
                                                  .getImageFromDevice(
                                                      fromGallery: false);

                                              if (memImg != null) {
                                                setState(() {
                                                  _back = memImg;
                                                });
                                              }

                                              Navigator.pop(context);
                                            },
                                          ),
                                          if (_front != null)
                                            ListTile(
                                              title:
                                                  const Text("Remover imagem"),
                                              onTap: () async {
                                                setState(() {
                                                  _back = null;
                                                });

                                                Navigator.pop(context);
                                              },
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _front != null
                                        ? Image.memory(_back!.bytes).image
                                        : Image.asset(
                                                utils.AssetManager.noImagePath)
                                            .image,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: SizedBox(
                                  height: 65,
                                  child: Stack(
                                    children: [
                                      Container(
                                        color: Colors.black.withOpacity(0.25),
                                      ),
                                      const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: Colors.white,
                                          size: utils.iconButtonSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancelar"),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: () async {
                              var cardId = const Uuid().v4().toString();

                              String? frontPath;
                              String? backPath;

                              if (_front != null) {
                                frontPath =
                                    await utils.storeCardImageIntoAppFolder(
                                  image: _front!,
                                  isFront: true,
                                  deckId: widget.deck.id,
                                  cardId: cardId,
                                );
                              }

                              if (_back != null) {
                                frontPath =
                                    await utils.storeCardImageIntoAppFolder(
                                  image: _back!,
                                  isFront: false,
                                  deckId: widget.deck.id,
                                  cardId: cardId,
                                );
                              }

                              setState(() {
                                _cardList.add(
                                  ms_entities.Card(
                                    id: cardId,
                                    frontText: _frontText.text,
                                    backText: _backText.text,
                                    frontImage: frontPath,
                                    backImage: backPath,
                                  ),
                                );

                                _collectionCubit.updateDeck(
                                  widget.deck.copyWith(cards: _cardList),
                                );
                              });

                              Navigator.pop(context);
                            },
                            child: const Text("Adicionar"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

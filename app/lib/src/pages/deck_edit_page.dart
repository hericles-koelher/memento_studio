import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memento_studio/src/entities.dart';

import '../utils.dart' as utils;

class DeckEditPage extends StatefulWidget {
  final Deck _deck;

  const DeckEditPage({Key? key, required Deck deck})
      : _deck = deck,
        super(key: key);

  @override
  State<DeckEditPage> createState() => _DeckEditPageState();
}

class _DeckEditPageState extends State<DeckEditPage> {
  late Deck _deck;
  utils.MemoryImage? _cover;

  @override
  void initState() {
    super.initState();

    _deck = widget._deck;
  }

  @override
  Widget build(BuildContext context) {
    Image image;

    if (_cover != null) {
      image = Image.memory(_cover!.bytes);
    } else if (_deck.cover != null) {
      image = Image.file(File(_deck.cover!));
    } else {
      image = Image.asset(utils.AssetManager.noImagePath);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edição de baralho"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(utils.borderRadius),
                          ),
                          contentPadding: const EdgeInsets.all(5),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("Galeria"),
                                onTap: () async {
                                  var memImg = await utils.getImageFromDevice(
                                      fromGallery: true);

                                  if (memImg != null) {
                                    setState(() {
                                      _cover = memImg;
                                    });
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text("Câmera"),
                                onTap: () async {
                                  var memImg = await utils.getImageFromDevice(
                                      fromGallery: false);

                                  if (memImg != null) {
                                    setState(() {
                                      _cover = memImg;
                                    });
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                              if (_cover != null)
                                ListTile(
                                  title: const Text("Remover imagem"),
                                  onTap: () async {
                                    setState(() {
                                      _cover = null;
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
                    height: utils.deckCoverSize,
                    width: double.infinity,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image.image,
                        fit: BoxFit.cover,
                      ),
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

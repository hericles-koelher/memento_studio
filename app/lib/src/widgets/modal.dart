import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart' as ms_entities;
import '../utils.dart' as utils;

class Modal extends StatefulWidget {
  final ms_entities.Deck deck;
  final ms_entities.Card? card;
  final Function(ms_entities.Card) onDone;

  const Modal({
    Key? key,
    this.card,
    required this.onDone,
    required this.deck,
  }) : super(key: key);

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  late final Logger _logger = KiwiContainer().resolve();

  final _frontText = TextEditingController();
  final _backText = TextEditingController();

  utils.MemoryImage? _front;
  utils.MemoryImage? _back;

  @override
  void initState() {
    super.initState();

    var c = widget.card;

    if (c != null) {
      _frontText.text = c.frontText ?? "";
      _backText.text = c.backText ?? "";

      if (c.frontImage != null && c.frontImage!.isNotEmpty) {
        utils.getImageBytes(c.frontImage!).then((value) {
          setState(() {
            _front = utils.MemoryImage(
              extension: utils.getFileExtension(c.frontImage!),
              bytes: value,
            );
          });
        });
      }

      if (c.backImage != null && c.backImage!.isNotEmpty) {
        utils.getImageBytes(c.backImage!).then((value) {
          setState(() {
            _back = utils.MemoryImage(
              extension: utils.getFileExtension(c.backImage!),
              bytes: value,
            );
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _front = _back = null;

        _frontText.clear();
        _backText.clear();

        return true;
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          utils.horizontalPadding,
          utils.verticalPadding,
          utils.horizontalPadding,
          MediaQuery.of(context).viewInsets.bottom + 25,
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
                      maxLength: utils.Validator.cardQuestionOrAnswerMaxLength,
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
                                      var memImg =
                                          await utils.getImageFromDevice(
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
                                      var memImg =
                                          await utils.getImageFromDevice(
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
                                      title: const Text("Remover imagem"),
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
                          border: Border.all(
                            color: Colors.black,
                            width: utils.borderWidth,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _front != null
                                ? Image.memory(_front!.bytes).image
                                : Image.asset(utils.AssetManager.noImagePath)
                                    .image,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: 65,
                          child: Stack(
                            children: [
                              Container(
                                color:
                                    utils.MSTheme.darkPurple.withOpacity(0.25),
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
                      maxLength: utils.Validator.cardQuestionOrAnswerMaxLength,
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
                                  utils.borderRadius,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(5),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: const Text("Galeria"),
                                    onTap: () async {
                                      var memImg =
                                          await utils.getImageFromDevice(
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
                                      var memImg =
                                          await utils.getImageFromDevice(
                                              fromGallery: false);

                                      if (memImg != null) {
                                        setState(() {
                                          _back = memImg;
                                        });
                                      }

                                      Navigator.pop(context);
                                    },
                                  ),
                                  if (_back != null)
                                    ListTile(
                                      title: const Text("Remover imagem"),
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
                          border: Border.all(
                            color: Colors.black,
                            width: utils.borderWidth,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _back != null
                                ? Image.memory(_back!.bytes).image
                                : Image.asset(utils.AssetManager.noImagePath)
                                    .image,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          height: 65,
                          child: Stack(
                            children: [
                              Container(
                                color:
                                    utils.MSTheme.darkPurple.withOpacity(0.25),
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
            const SizedBox(height: 15),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MSButton(
                    child: const Text("Cancelar"),
                    onPressed: () => GoRouter.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  MSButton(
                    onPressed: () async {
                      var cardId =
                          widget.card?.id ?? const Uuid().v4().toString();

                      String? frontPath;
                      String? backPath;

                      if (_front != null) {
                        frontPath = await utils.storeCardImageIntoAppFolder(
                          image: _front!,
                          isFront: true,
                          deckId: widget.deck.id,
                          cardId: cardId,
                        );
                      }

                      if (_back != null) {
                        backPath = await utils.storeCardImageIntoAppFolder(
                          image: _back!,
                          isFront: false,
                          deckId: widget.deck.id,
                          cardId: cardId,
                        );
                      }

                      widget.onDone(
                        ms_entities.Card(
                          id: cardId,
                          frontText: _nullifyString(_frontText.text),
                          backText: _nullifyString(_backText.text),
                          frontImage: frontPath,
                          backImage: backPath,
                        ),
                      );

                      _front = _back = null;

                      _frontText.clear();
                      _backText.clear();

                      Navigator.pop(context);
                    },
                    child:
                        Text(widget.card != null ? "Atualizar" : "Adicionar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _nullifyString(String str) {
    return str.isNotEmpty ? str : null;
  }

  @override
  void dispose() {
    _frontText.dispose();
    _backText.dispose();

    super.dispose();
  }
}

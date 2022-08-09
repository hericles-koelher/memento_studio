import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';

import '../state_managers.dart';
import '../utils.dart' as utils;

class DeckEditPage extends StatefulWidget {
  final String deckId;

  const DeckEditPage({
    Key? key,
    required this.deckId,
  }) : super(key: key);

  @override
  State<DeckEditPage> createState() => _DeckEditPageState();
}

class _DeckEditPageState extends State<DeckEditPage> {
  late final DeckCollectionCubit _collectionCubit;
  late final Logger _logger;

  late Deck _deck;

  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tagController = TextEditingController();
  final _tagList = <String>[];
  final _scrollController = ScrollController();

  late StreamSubscription<bool> _keyboardStream;

  utils.MemoryImage? _cover;

  _DeckEditPageState() {
    var kiwi = KiwiContainer();

    _collectionCubit = kiwi.resolve();
    _logger = kiwi.resolve();
  }

  void _scrollAnimation(bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      _scrollController.animateTo(
        _scrollController.offset + utils.keyboardHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.offset - utils.keyboardHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _keyboardStream =
        KeyboardVisibilityController().onChange.listen(_scrollAnimation);

    _deck = _collectionCubit.state.decks.firstWhere(
      (element) => element.id == widget.deckId,
    );
    _nameController.text = _deck.name;
    _descriptionController.text = _deck.description ?? "";

    _tagList.addAll(_deck.tags);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text("Edição de Baralho"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _logger.i(
                "Formulário de criação de usuário válido.",
              );

              String? coverPath = _deck.cover;

              if (_cover != null) {
                if (_deck.cover != null && _deck.cover!.isNotEmpty) {
                  var imageFile = File(_deck.cover!);

                  await imageFile.delete();
                }

                coverPath = await utils.storeDeckCoverImageIntoAppFolder(
                  image: _cover!,
                  deckId: _deck.id,
                );
              }

              _deck = _deck.copyWith(
                tags: _tagList,
                name: _nameController.text,
                description: _descriptionController.text,
                cover: coverPath,
                lastModification: DateTime.now(),
              );

              await _collectionCubit.updateDeck(_deck);

              _logger.i(
                "Baralho ${_deck.id}, de Nome ${_deck.name} foi atualizado.",
              );

              GoRouter.of(context).pop();
            } else {
              _logger.i("Formulário não foi aceito");
            }
          },
          icon: const FaIcon(
            FontAwesomeIcons.check,
          ),
        ),
      ],
    );

    var bottomPadding = MediaQuery.of(context).viewInsets.bottom -
        appBar.preferredSize.height / 2;

    Image image;

    if (_cover != null) {
      image = Image.memory(_cover!.bytes);
    } else if (_deck.cover != null) {
      image = Image.file(File(_deck.cover!));
    } else {
      image = Image.asset(utils.AssetManager.noImagePath);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: utils.horizontalPadding,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Form(
                key: _formKey,
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(
                    top: utils.verticalScrollPadding,
                    bottom: utils.verticalScrollPadding +
                        (bottomPadding > 0 ? bottomPadding : 0),
                  ),
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
                                      var memImg =
                                          await utils.getImageFromDevice(
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
                                      var memImg =
                                          await utils.getImageFromDevice(
                                              fromGallery: false);

                                      if (memImg != null) {
                                        setState(() {
                                          _cover = memImg;
                                        });
                                      }

                                      Navigator.pop(context);
                                    },
                                  ),
                                  if (_deck.cover != null || _cover != null)
                                    ListTile(
                                      title: const Text("Remover imagem"),
                                      onTap: () async {
                                        setState(() {
                                          _deck = _deck.copyWith(cover: null);
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
                        width: constraints.biggest.width,
                        height: constraints.biggest.width / 3 * 2,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image.image,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(utils.borderRadius),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              color: utils.MSTheme.darkPurple.withOpacity(0.25),
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
                    const SizedBox(height: utils.verticalSpace * 3),
                    TextFormField(
                      maxLength: utils.Validator.deckNameMaxLength,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(),
                      ),
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return "Nome inválido";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: utils.verticalSpace / 2),
                    TextFormField(
                      maxLines: null,
                      maxLength: utils.Validator.deckDescriptionMaxLength,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_tagList.isNotEmpty) ...[
                      const SizedBox(height: utils.verticalSpace),
                      Wrap(
                        spacing: 10,
                        children: _tagList
                            .map(
                              (e) => Chip(
                                backgroundColor: Colors
                                    .accents[_tagList.indexOf(e) %
                                        Colors.accents.length]
                                    .shade100,
                                label: Text(e),
                                onDeleted: () {
                                  setState(() {
                                    _tagList
                                        .removeWhere((element) => element == e);
                                  });
                                },
                                deleteIcon: const FaIcon(
                                  FontAwesomeIcons.x,
                                  size: 12,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(utils.borderRadius),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _tagController,
                                      decoration: const InputDecoration(
                                        labelText: "Tag",
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLength: 32,
                                      inputFormatters: [
                                        FilteringTextInputFormatter(
                                          " ",
                                          allow: false,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancelar"),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _tagList
                                                    .add(_tagController.text);
                                                _tagController.clear();
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: const Text("Adicionar")),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.plus,
                          size: 16,
                        ),
                        label: const Text("Adicionar Tag")),
                    const SizedBox(height: utils.verticalSpace),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyboardStream.cancel();

    super.dispose();
  }
}

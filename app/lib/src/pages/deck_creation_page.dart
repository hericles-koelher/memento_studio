import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/state_managers/cubit/deck_collection_cubit.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart';
import '../utils.dart' as utils;

// https://stackoverflow.com/questions/50736571/when-i-select-a-textfield-the-keyboard-moves-over-it
// TODO: arrumar problema com teclado na frente do textfield
class DeckCreationPage extends StatefulWidget {
  const DeckCreationPage({Key? key}) : super(key: key);

  @override
  State<DeckCreationPage> createState() => _DeckCreationPageState();
}

class _DeckCreationPageState extends State<DeckCreationPage> {
  late final DeckCollectionCubit _collectionCubit;
  late final Logger _logger;
  late final Uuid _uuid;

  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tagController = TextEditingController();
  final _tagList = <String>[];

  utils.MemoryImage? _cover;

  _DeckCreationPageState() {
    var kiwi = KiwiContainer();

    _collectionCubit = kiwi.resolve();
    _logger = kiwi.resolve();
    _uuid = kiwi.resolve();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: const Text("Criação de Baralho"),
      centerTitle: true,
    );

    var bottomPadding = MediaQuery.of(context).viewInsets.bottom -
        appBar.preferredSize.height / 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Scrollbar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: utils.horizontalPadding,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Form(
              key: _formKey,
              child: ListView(
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
                      width: constraints.biggest.width,
                      height: constraints.biggest.width / 3 * 2,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (_cover != null
                                  ? Image.memory(_cover!.bytes)
                                  : Image.asset(
                                      utils.AssetManager.noImagePath,
                                    ))
                              .image,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(utils.borderRadius),
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
                                      labelText: "Descrição",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancelar"),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _tagList.add(_tagController.text);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _logger.i(
                              "Formulário de criação de usuário válido.",
                            );

                            String deckId = _uuid.v4();

                            String? coverPath;

                            if (_cover != null) {
                              coverPath =
                                  await utils.storeDeckCoverImageIntoAppFolder(
                                image: _cover!,
                                deckId: deckId,
                              );
                            }

                            var deck = Deck(
                              id: deckId,
                              lastModification: DateTime.now(),
                              name: _nameController.text,
                              description: _descriptionController.text,
                              cover: coverPath,
                              tags: _tagList,
                            );

                            await _collectionCubit.createDeck(deck);

                            _logger.i(
                              "Baralho $deckId, de Nome ${deck.name} foi salvo localmente.",
                            );

                            GoRouter.of(context).goNamed(
                              utils.MSRouter.deckRouteName,
                              params: {
                                "deckId": deckId,
                              },
                            );
                          } else {
                            _logger.i("Formulário não foi aceito");
                          }
                        },
                        child: const Text("Criar"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

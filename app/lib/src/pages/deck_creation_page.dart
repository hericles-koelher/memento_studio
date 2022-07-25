import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

import '../entities.dart';
import '../utils.dart' as utils;

// TODO: adicionar tags nessa página...

class DeckCreationPage extends StatefulWidget {
  const DeckCreationPage({Key? key}) : super(key: key);

  @override
  State<DeckCreationPage> createState() => _DeckCreationPageState();
}

class _DeckCreationPageState extends State<DeckCreationPage> {
  final Logger _logger = KiwiContainer().resolve();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  utils.MemoryImage? _cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Criação de Baralho"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom / 2,
          ),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: constraints,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 4,
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
                        margin: const EdgeInsets.symmetric(
                          horizontal: utils.horizontalPadding,
                        ),
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
                  ),
                  const SizedBox(height: utils.verticalSpace * 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: utils.horizontalPadding,
                    ),
                    child: TextFormField(
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
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          utils.Validator.deckNameMaxLength,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: utils.verticalSpace),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: utils.horizontalPadding,
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          utils.Validator.deckDescriptionMaxLength,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: utils.verticalSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _logger.i(
                              "Formulário de criação de usuário válido.",
                            );

                            // TODO: Criar o bendito deck e redirecionar para página de edição...

                            // TODO: salvar baralho

                            GoRouter.of(context).goNamed(
                              utils.MSRouter.deckEditRouteName,
                              extra: Deck(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                lastModification: DateTime.now(),
                                id: "abl",
                              ),
                            );
                          } else {
                            _logger.i("Formulário não foi aceito");
                          }
                        },
                        child: const Text("Criar"),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/utils.dart';

import '../utils.dart' as utils;

class DeckCreationPage extends StatefulWidget {
  const DeckCreationPage({Key? key}) : super(key: key);

  @override
  State<DeckCreationPage> createState() => _DeckCreationPageState();
}

class _DeckCreationPageState extends State<DeckCreationPage> {
  final Logger _logger = KiwiContainer().resolve();
  final _formKey = GlobalKey<FormState>();
  utils.MemoryImage? _cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  if (_cover != null)
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.memory(_cover!.bytes).image,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Nome",
                              border: OutlineInputBorder(),
                            ),
                            validator: (name) {
                              if (name == null || !Validator.isDeckName(name)) {
                                return "Nome inválido";
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            var memImg = await getImageFromDeviceGallery();

                            setState(() {
                              if (memImg != null) {
                                _cover = memImg;
                              }
                            });
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.camera,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Descrição",
                        border: OutlineInputBorder(),
                      ),
                      validator: (description) {
                        if (description != null &&
                            !Validator.isDeckDescription(description)) {
                          return "Descrição inválida, por favor utilize até 256 caracteres";
                        }

                        return null;
                      },
                    ),
                  ),
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

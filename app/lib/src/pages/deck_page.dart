import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';

import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:uuid/uuid.dart';

class DeckPage extends StatefulWidget {
  final String deckId;

  const DeckPage({
    Key? key,
    required this.deckId,
  }) : super(key: key);

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  final DeckRepositoryInterface apiRepo = KiwiContainer().resolve();
  final DeletedDeckListRepository deletedDeckListRepository =
      KiwiContainer().resolve();
  final DeckCollectionCubit collectionCubit = KiwiContainer().resolve();
  final AuthCubit auth = KiwiContainer().resolve();

  late Deck deck;

  @override
  void initState() {
    deck = collectionCubit.state.decks.firstWhere(
      (element) => element.id == widget.deckId,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var popUpMenu = PopupMenuButton(itemBuilder: (context) {
      return [
        const PopupMenuItem<int>(
          value: 1,
          child: Text("Editar"),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text("Ver cartas"),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Text("Tornar público"),
        ),
        const PopupMenuItem<int>(
          value: 4,
          child: Text(
            "Deletar",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ];
    }, onSelected: (value) {
      switch (value) {
        case 1:
          GoRouter.of(context).pushNamed(
            MSRouter.deckEditRouteName,
            params: {
              "deckId": widget.deckId,
            },
          );
          break;
        case 2:
          GoRouter.of(context).pushNamed(
            MSRouter.cardListRouteName,
            params: {
              "deckId": widget.deckId,
            },
          );
          break;

        case 3:
          showTurnPublicDialog();
          break;
        case 4:
          showDeleteDeckDialog();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [popUpMenu],
      ),
      body: BlocBuilder<DeckCollectionCubit, DeckCollectionState>(
          bloc: collectionCubit,
          builder: (context, state) {
            deck = state.decks.firstWhere(
              (element) => element.id == widget.deckId,
            );

            Logger().d("DECK COVER: ${deck.cover}");

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // TODO: Adicionar nas constantes
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (deck.cover != null
                                ? Image.memory(
                                    File(deck.cover!).readAsBytesSync(),
                                  )
                                : Image.asset(AssetManager.noImagePath))
                            .image,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deck.name,
                          style: const TextStyle(fontSize: 32.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          deck.description ?? "",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 10.0),
                        Wrap(
                          spacing: 4.0,
                          runSpacing: -10.0,
                          children:
                              (deck.tags.isNotEmpty ? deck.tags : ["Sem Tags"])
                                  .map((e) => Chip(label: Text(e)))
                                  .toList(),
                        ),
                        const SizedBox(height: 5.0),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Por Fulano de tal",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${deck.cards.length} cartas",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: () {
            if (deck.cards.isEmpty) {
              showNoCardsDialog();
              return;
            }

            deck.cards.shuffle();

            GoRouter.of(context).goNamed(
              MSRouter.studyRouteName,
              params: {
                "deckId": deck.id,
              },
            );
          },
          child: const Text('Começar'),
        ),
      ),
    );
  }

  void showNoCardsDialog() {
    var noCardsDescription = "Crie cartas para ele!";

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sem cartas'),
        content: Text(
            "Ainda não há cartas disponíveis nesse baralho. $noCardsDescription"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text("Criar"),
          ),
        ],
      ),
    );
  }

  void showCopyDeckDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext copyContext) => AlertDialog(
        title: Text.rich(
          TextSpan(
            text: "Deseja fazer uma cópia de ",
            children: <TextSpan>[
              TextSpan(
                text: "'${deck.name}'",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: "?")
            ],
          ),
        ),
        content: Text.rich(
          TextSpan(
            text: "Uma cópia do baralho ",
            children: <TextSpan>[
              TextSpan(
                text: "'${deck.name}'",
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const TextSpan(text: " será adicionada a sua coleção.")
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tira dialog para mostrar loading
              showLoadingDialog();

              var isThereError = false;

              if (auth.state is Authenticated) {
                var result = await apiRepo
                    .copyDeck(deck.id); // Salva baralho no servidor

                if (result is Error) {
                  isThereError = true; // Tratar melhor esse erro talvez
                } else if (result is Success) {
                  var copy = result.value as Deck;

                  await collectionCubit.createDeck(copy);
                }
              } else {
                await collectionCubit.createDeck(
                  deck.copyWith(
                    id: const Uuid().v4().toString(),
                  ),
                );
              }

              Navigator.pop(context); // Retira loading
              if (isThereError) {
                showOkWithIconDialog(
                  "Falha ao salvar baralho no servidor",
                  "Não foi possível fazer a cópia do baralho no servidor. Tente sincronizar mais tarde.",
                  icon: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50.0,
                    semanticLabel: 'Error',
                  ),
                );
              } else {
                showOkWithIconDialog(
                  "Cópia feita com sucesso",
                  "Uma cópia deste baralho foi adicionada a sua coleção.",
                  icon: const Icon(
                    Icons.task_alt,
                    color: Colors.green,
                    size: 50.0,
                    semanticLabel: 'Success',
                  ),
                );
              }
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void showTurnPublicDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext pcontext) => AlertDialog(
        title: const Text('Tornar baralho público?'),
        content: const Text(
            "Ao confirmar, esse baralho ficará disponível para outros usuários utilizarem e clonarem em suas próprias coleções. Lembre-se de sincronizar o baralho antes de torná-lo público. Tem certeza disso?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Não', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tira dialog para mostrar loading
              showLoadingDialog();

              if (auth.state is Authenticated) {
                var result = await apiRepo.updateDeck(
                  deck.id,
                  <String, bool>{"isPublic": true},
                  <String, Uint8List>{},
                );

                Navigator.pop(context);

                if (result is Error) {
                  showOkWithIconDialog(
                    "Falha ao tornar baralho público",
                    "Não foi possível tornar este baralho público. Tente novamente mais tarde.",
                    icon: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50.0,
                      semanticLabel: 'Error',
                    ),
                  );
                } else if (result is Success) {
                  showOkWithIconDialog(
                    "Baralho público com sucesso",
                    "Agora este baralho é público e outras pessoas poderão utilizá-lo.",
                    icon: const Icon(
                      Icons.task_alt,
                      color: Colors.green,
                      size: 50.0,
                      semanticLabel: 'Success',
                    ),
                  );
                }
              } else {
                Navigator.pop(context);
                showOkWithIconDialog("Usuário não logado",
                    "Você precisa estar logado para tornar este baralho público.");
              }
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }

  void showDeleteDeckDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Deletar baralho?'),
        content: const Text(
            "Ao confirmar, este baralho será removido da sua coleção. Tem certeza disso?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Não', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              await collectionCubit.deleteDeck(deck.id);

              if (auth.state is Authenticated) {
                await deletedDeckListRepository.addId(deck.id);
              }

              GoRouter.of(context).pop();
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  void showOkWithIconDialog(String title, String subtitle, {Icon? icon}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 130,
          child: Column(
            children: [
              icon ?? Container(),
              const SizedBox(height: 15.0),
              Text(subtitle),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}

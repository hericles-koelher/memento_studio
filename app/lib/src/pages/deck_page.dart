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
import 'package:memento_studio/src/widgets.dart';
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

  static const withoutTagChip = Chip(
    label: Text("Sem Tags"),
  );

  @override
  void initState() {
    bool init = false;

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
        shape: const ContinuousRectangleBorder(side: BorderSide.none),
      ),
      body: BlocBuilder<DeckCollectionCubit, DeckCollectionState>(
          bloc: collectionCubit,
          builder: (context, state) {
            deck = state.decks.firstWhere(
              (element) => element.id == widget.deckId,
            );

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 2 * MediaQuery.of(context).size.height / 5,
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: borderWidth,
                        ),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ((deck.cover != null && deck.cover!.isNotEmpty)
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
                          children: deck.tags.isNotEmpty
                              ? deck.tags
                                  .map(
                                    (e) => Chip(
                                      label: Text(e),
                                      backgroundColor: Colors
                                          .accents[deck.tags.indexOf(e) %
                                              Colors.accents.length]
                                          .shade100,
                                    ),
                                  )
                                  .toList()
                              : [withoutTagChip],
                        ),
                        const SizedBox(height: 5.0),
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
          child: MSButton(
            child: const Text("Começar"),
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
          )),
    );
  }

  void showNoCardsDialog() {
    var noCardsDescription = "Crie cartas para ele!";

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sem cartas'),
        content: Text(
          "Ainda não há cartas disponíveis nesse baralho. $noCardsDescription",
        ),
        actions: <Widget>[
          MSButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text("Cancelar"),
          ),
          MSButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text("Criar"),
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
            "Ao confirmar, esse baralho ficará disponível para outros usuários utilizarem e clonarem em suas próprias coleções. Tem certeza disso?"),
        actions: <Widget>[
          MSButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.red),
            ),
          ),
          MSButton(
            onPressed: () async {
              Navigator.pop(context); // Tira dialog para mostrar loading
              showLoadingDialog();

              if (auth.state is Authenticated) {
                var pDeck = deck.copyWith(
                    isPublic: true, lastModification: DateTime.now());
                var images = await getMapOfImages(deck);

                var result = await apiRepo.saveDeck(
                  pDeck,
                  images,
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
                  await collectionCubit.updateDeck(pDeck);

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
      builder: (BuildContext deleteContext) => AlertDialog(
        title: const Text('Deletar baralho?'),
        content: const Text(
            "Ao confirmar, este baralho será removido da sua coleção. Tem certeza disso?"),
        actions: <Widget>[
          MSButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.red),
            ),
          ),
          MSButton(
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ?? Container(),
            const SizedBox(height: 15.0),
            Text(subtitle),
          ],
        ),
        actions: <Widget>[
          MSButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}

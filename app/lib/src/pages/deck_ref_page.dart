import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/entities.dart';

import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:uuid/uuid.dart';

class DeckRefPage extends StatefulWidget {
  final Deck deck;

  const DeckRefPage({
    Key? key,
    required this.deck,
  }) : super(key: key);

  @override
  State<DeckRefPage> createState() => _DeckRefPageState();
}

class _DeckRefPageState extends State<DeckRefPage> {
  final DeckRepositoryInterface apiRepo = KiwiContainer().resolve();
  final DeckCollectionCubit collectionCubit = KiwiContainer().resolve();
  final AuthCubit auth = KiwiContainer().resolve();

  static const _withoutTagChip = Chip(label: Text("Sem Tags"));

  @override
  Widget build(BuildContext context) {
    dynamic imageCover = getDeckCover(context);

    var popUpMenu = PopupMenuButton(
        itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Fazer uma cópia"),
              )
            ],
        onSelected: (_) {
          showCopyDeckDialog();
        });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [popUpMenu],
        shape: const ContinuousRectangleBorder(side: BorderSide.none),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    children: widget.deck.tags.isEmpty
                        ? ([_withoutTagChip])
                        : widget.deck.tags
                            .map(
                              (e) => Chip(
                                label: Text(e),
                                backgroundColor: Colors
                                    .accents[widget.deck.tags.indexOf(e) %
                                        Colors.accents.length]
                                    .shade100,
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 5.0),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${widget.deck.cards.length} cartas",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDeckCover(BuildContext context) {
    var imageHeight = 2 * MediaQuery.of(context).size.height / 5;

    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: imageHeight,
      imageUrl: "$baseUrl/${widget.deck.cover}",
      imageBuilder: (context, image) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(
              color: Colors.black,
              width: borderWidth,
            ),
          ),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: borderWidth,
            ),
          ),
          image: DecorationImage(
            image: AssetImage(AssetManager.noImagePath),
            fit: BoxFit.cover,
          ),
        ),
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
                text: "'${widget.deck.name}'",
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
                text: "'${widget.deck.name}'",
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
                    .copyDeck(widget.deck.id); // Salva baralho no servidor

                if (result is Error) {
                  isThereError = true; // Tratar melhor esse erro talvez
                } else if (result is Success) {
                  var copy = (result as Success).value as Deck;
                  var newLocalDeck = await updateLocalDeckGivenRemote(copy);

                  await collectionCubit.createDeck(newLocalDeck);
                }
              } else {
                var newLocalDeck =
                    await updateLocalDeckGivenRemote(widget.deck.copyWith(
                  id: const Uuid().v4().toString(),
                ));
                await collectionCubit.createDeck(newLocalDeck);
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

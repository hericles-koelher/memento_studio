import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:memento_studio/src/widgets/textfield_tags.dart';

import 'deck_page.dart';

// TODO: utilizar infinite_pagination_scroll
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final DeckReferenceRepositoryInterface repo = KiwiContainer().resolve();
  List<String> tags = <String>[];
  double appBarSize = 110;

  @override
  Widget build(BuildContext context) {
    var searchBarWithTags = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFieldTags(
        tags: tags,
        onSearchAction: (_, __) {
          print("TODO: Fazer pesquisa");
        },
        onAddTag: (tag) {
          tag.replaceAll(' ', ''); // Retira espaços

          if (tag.isEmpty) return;

          setState(() {
            tags.add(tag);
            appBarSize = 150;
          });
        },
        onDeleteTag: (tag) {
          setState(() {
            tags.remove(tag);

            if (tags.isEmpty) appBarSize = 120;
          });
        },
      ),
    );

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Descubra baralhos"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(appBarSize),
          child: searchBarWithTags,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: FutureBuilder<DeckListReferencesResult>(
            future: repo.getDecks(1, 10),
            builder: (_, AsyncSnapshot<DeckListReferencesResult> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  var decksResult = snapshot.data;

                  if (decksResult is Success) {
                    var decks =
                        (decksResult as Success<List<DeckReference>>).value;

                    return ListView.separated(
                      itemBuilder: (_, index) => InkWell(
                        onTap: () => goToDeckPage(decks[index].id, context),
                        child: DeckListTile(deck: decks[index]),
                      ),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: decks.length,
                    );
                  }
                  Logger logger = KiwiContainer().resolve();
                  logger.e((decksResult as Error).exception.toString());
                  return const Center(child: Text("Deu merda"));
                default:
                  return const Text("Error");
              }
            }),
      ),
    );
  }

  Future<void> goToDeckPage(String id, BuildContext context) async {
    final deckResult = await repo.getDeck(id);

    if (deckResult is Error) {
      final scaffold = ScaffoldMessenger.of(context);

      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Erro ao pegar baralho público'),
        ),
      );

      return;
    }

    final deck = (deckResult as Success).value;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeckPage(deck: deck, isPersonalDeck: false),
      ),
    );
  }
}

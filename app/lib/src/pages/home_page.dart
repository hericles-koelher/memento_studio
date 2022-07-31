import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memento_studio/src/pages/deck_page.dart';
import 'package:go_router/go_router.dart';
import 'package:memento_studio/src/widgets.dart';

import '../utils.dart';
import '../widgets/textfield_tags.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tags = <String>[];

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;

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
          });
        },
        onDeleteTag: (tag) {
          setState(() {
            tags.remove(tag);
          });
        },
      ),
    );

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Memento Studio"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: searchBarWithTags,
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: LayoutBuilder(
            builder: (context, constraints) => AlignedGridView.count(
              crossAxisCount: crossAxisCount,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 25,
              ),
              itemCount: FakeData.decks.length,
              itemBuilder: (_, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeckPage(
                              deck: FakeData.decks[index],
                              isPersonalDeck: true,
                            )),
                  );
                },
                child: DeckCard(
                  deck: FakeData.decks[index],
                  defaultCoverColor: Colors
                      .accents[Colors.accents.length % (index + 1)].shade100,
                  coverDimension: constraints.maxWidth / crossAxisCount,
                  margin: const EdgeInsets.all(5),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            GoRouter.of(context).goNamed(MSRouter.deckCreationRouteName),
      ),
    );
  }
}

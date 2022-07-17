import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities/local/result.dart';
import 'package:memento_studio/src/repositories/interfaces/deck_reference_repository_interface.dart';
import 'package:memento_studio/src/widgets.dart';

import '../entities.dart';
import '../entities/local/deck/deck_reference.dart';
import '../repositories/deck_reference_repository.dart';
import '../utils.dart';

// TODO: utilizar infinite_pagination_scroll
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final DeckReferenceRepositoryInterface repo = KiwiContainer().resolve();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Descubra baralhos"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquisar",
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: FutureBuilder<DeckListResult>(
            future: repo.getDecks(1, 10),
            builder: (_, AsyncSnapshot<DeckListResult> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  var decksResult = snapshot.data;

                  if (decksResult is Success) {
                    var decks =
                        (decksResult as Success<List<DeckReference>>).value;

                    return ListView.separated(
                      itemBuilder: (_, index) =>
                          DeckListTile(deck: decks[index]),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: decks.length,
                    );
                  }
                  Logger logger = KiwiContainer().resolve();
                  logger.e((decksResult as Error).exception.toString());
                  return const Center(child: Text("Deu merda"));
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Text('Result: ${snapshot.data}');
              }
            }),
      ),
    );
  }
}

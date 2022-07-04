import 'package:flutter/material.dart';
import 'package:memento_studio/src/widgets.dart';

import '../entities.dart';
import '../utils.dart';

// TODO: utilizar infinite_pagination_scroll
class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

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
        child: ListView.separated(
          itemCount: FakeData.decks.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) => DeckListTile(deck: FakeData.decks[index]),
        ),
      ),
    );
  }
}

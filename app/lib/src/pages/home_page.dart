import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:memento_studio/src/widgets.dart';

import '../utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Memento Studio"),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
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
              itemBuilder: (_, index) => DeckCard(
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

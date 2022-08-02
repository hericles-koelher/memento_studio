import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:memento_studio/src/widgets/textfield_tags.dart';

import '../entities.dart';
import '../utils.dart';
import 'deck_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 10;
  List<String> tags = <String>[];
  double appBarSize = 110;

  late final Logger _logger;
  late final DeckCollectionCubit _collectionCubit;

  StreamSubscription<DeckCollectionState>? _subscription;

  final PagingController<int, Deck> _pagingController =
      PagingController(firstPageKey: 0);

  _HomePageState() {
    var kiwi = KiwiContainer();

    _logger = kiwi.resolve();
    _collectionCubit = kiwi.resolve();
  }

  @override
  void initState() {
    _subscription = _collectionCubit.stream.listen((state) {
      _logger.i('Atualizando lista de decks');

      _pagingController.value = PagingState(
        itemList: state.decks,
        nextPageKey: state.count,
      );

      if (state is FinalDeckCollection) {
        _logger.i("Carregando página final");

        _pagingController.appendLastPage(List.empty());
      }
    });

    _pagingController.addPageRequestListener((pageKey) {
      _collectionCubit.loadMore(_pageSize);
    });

    _collectionCubit.loadMore(_pageSize);

    super.initState();
  }

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
          tag = tag.replaceAll(" ", "").toLowerCase();

          if (tag.isEmpty || tags.contains(tag)) return;

          setState(() {
            tags.add(tag);
            appBarSize = 150;
          });
        },
        onDeleteTag: (tag) {
          setState(() {
            tags.remove(tag);

            if (tags.isEmpty) appBarSize = 110;
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
          preferredSize: Size.fromHeight(appBarSize),
          child: searchBarWithTags,
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: LayoutBuilder(
              builder: (context, constraints) => CustomScrollView(
                slivers: [
                  PagedSliverGrid<int, Deck>(
                    pagingController: _pagingController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                    ),
                    builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, Deck deck, int index) =>
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DeckPage(
                                            deck: deck,
                                            isPersonalDeck: true,
                                          )),
                                );
                              },
                              child: DeckCard(
                                deck: deck,
                                coverDimension:
                                    constraints.maxWidth / crossAxisCount,
                              ),
                            )),
                  ),
                ],
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

  @override
  void dispose() {
    _pagingController.dispose();
    _subscription?.cancel();
    _collectionCubit.close();
    super.dispose();
  }
}

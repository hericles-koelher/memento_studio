import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/widgets.dart';

import '../entities.dart';
import '../utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 10;

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
                border: const OutlineInputBorder(),
              ),
            ),
          ),
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
                          GoRouter.of(context).goNamed(
                            MSRouter.cardListRouteName,
                            extra: deck,
                          );
                        },
                        child: DeckCard(
                          deck: deck,
                          coverDimension: constraints.maxWidth / crossAxisCount,
                        ),
                      ),
                    ),
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

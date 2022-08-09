import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:memento_studio/src/widgets.dart';
import 'package:memento_studio/src/widgets/textfield_tags.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const _pageSize = 10;
  static const appBarSizeWithoutTags = 110.0;
  static const appBarSizeWithTags = 150.0;

  final DeckReferenceRepositoryInterface repo = KiwiContainer().resolve();
  List<String> tags = <String>[];
  double appBarSize = appBarSizeWithoutTags;

  late final Logger _logger;
  late final DeckReferencesCubit _deckReferencesCubit;

  StreamSubscription<DeckReferencesState>? _subscription;

  final PagingController<int, DeckReference> _pagingController =
      PagingController(firstPageKey: 1);

  _ExplorePageState() {
    var kiwi = KiwiContainer();

    _logger = kiwi.resolve();
    _deckReferencesCubit = kiwi.resolve();
  }

  @override
  void initState() {
    _subscription = _deckReferencesCubit.stream.listen((state) {
      _logger.i('Atualizando lista de referências de baralho');

      _pagingController.value = PagingState(
        itemList: state.decks,
        nextPageKey: state.page,
      );

      if (state is FinalDeckReferences) {
        _logger.i("Carregando página final");

        _pagingController.appendLastPage(List.empty());
      }
    });

    _pagingController.addPageRequestListener((pageKey) {
      _deckReferencesCubit.loadMore(_pageSize);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchBarWithTags = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 10,
      ),
      child: TextFieldTags(
        tags: tags,
        onSearchAction: (name, searchTags) async {
          _deckReferencesCubit.setFilter(
              searchDecksFilter(name, searchTags), _pageSize);
        },
        onAddTag: (tag) {
          tag = tag.replaceAll(" ", "").toLowerCase();

          if (tag.isEmpty || tags.contains(tag)) return;

          setState(() {
            tags.add(tag);
            appBarSize = appBarSizeWithTags;
          });
        },
        onDeleteTag: (tag) {
          setState(() {
            tags.remove(tag);

            if (tags.isEmpty) appBarSize = appBarSizeWithoutTags;
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalScrollPadding,
            ),
            sliver: PagedSliverList<int, DeckReference>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<DeckReference>(
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                    "Nenhum deck encontrado...",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                itemBuilder: (context, deckRef, index) => InkWell(
                  onTap: () => goToDeckPage(deckRef.id, context),
                  child: Column(
                    children: [
                      DeckListTile(deck: deckRef),
                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

    GoRouter.of(context).goNamed(
      MSRouter.deckRefRouteName,
      extra: deck,
    );
  }

  Map<String, dynamic> searchDecksFilter(String name, List<String> searchTags) {
    var filterByNameAndTag = <String, dynamic>{
      "name": <String, dynamic>{
        "\$regex": '.*$name.*', // Contém o nome pesquisado
        "\$options": 'i', // Case insensitive
      },
    };

    if (tags.isNotEmpty) {
      filterByNameAndTag["tags"] = <String, dynamic>{"\$in": searchTags};
    }

    return filterByNameAndTag;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _subscription?.cancel();
    _deckReferencesCubit.resetState();
    super.dispose();
  }
}

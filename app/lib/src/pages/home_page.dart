import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/widgets.dart';

import '../entities.dart';
import '../utils.dart';

/// {@category Páginas}
/// Página principal da aplicação, exibe os baralhos salvos localmente do usuário.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 10;

  late final Logger _logger;
  late final DeckCollectionCubit _collectionCubit;
  late final AuthCubit auth;

  StreamSubscription<DeckCollectionState>? _subscription;

  final PagingController<int, Deck> _pagingController =
      PagingController(firstPageKey: 0);

  _HomePageState() {
    var kiwi = KiwiContainer();

    _logger = kiwi.resolve();
    _collectionCubit = kiwi.resolve();
    auth = KiwiContainer().resolve();
  }

  @override
  void initState() {
    super.initState();

    _subscription = _collectionCubit.stream.listen((state) {
      if (state is LoadingDeckCollection) {
        return;
      }

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
      if (_collectionCubit.state is! LoadingDeckCollection) {
        _collectionCubit.loadMore(_pageSize);
      }
    });

    _collectionCubit.loadMore(_pageSize);
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Memento Studio"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (auth.state is Unauthenticated) {
                GoRouter.of(context).goNamed(MSRouter.signInRouteName);
                return;
              }

              showSyncDialog();
            },
            icon: const Icon(Icons.sync),
          )
        ],
      ),
      body: BlocListener<DeckCollectionCubit, DeckCollectionState>(
        bloc: _collectionCubit,
        listenWhen: (prev, next) =>
            next is LoadingDeckCollection || prev is LoadingDeckCollection,
        listener: (context, state) {
          // Esses Future.delayed são RTND (Recursos Técnicos Não Documentados) ( ͡° ͜ʖ ͡°)

          if (state is LoadingDeckCollection) {
            Future.delayed(const Duration(milliseconds: 500)).then(
              (value) => showLoadingDialog(),
            );
          } else {
            Future.delayed(const Duration(milliseconds: 500)).then(
              (value) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }
        },
        child: SafeArea(
          child: Scrollbar(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: LayoutBuilder(
                builder: (context, constraints) => CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: verticalScrollPadding,
                      ),
                      sliver: PagedSliverGrid<int, Deck>(
                        pagingController: _pagingController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                        ),
                        builderDelegate: PagedChildBuilderDelegate(
                          noItemsFoundIndicatorBuilder: (_) => Center(
                            child: Text(
                              "Parece que você ainda não possui baralhos...",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          itemBuilder: (context, Deck deck, int index) =>
                              GestureDetector(
                            onTap: () {
                              GoRouter.of(context).goNamed(
                                MSRouter.deckRouteName,
                                params: {"deckId": deck.id},
                              );
                            },
                            child: DeckCard(
                              deck: deck,
                              coverDimension:
                                  constraints.maxWidth / crossAxisCount,
                            ),
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => GoRouter.of(context).goNamed(
          MSRouter.deckCreationRouteName,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _subscription?.cancel();

    super.dispose();
  }

  void showSyncDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext sContext) => AlertDialog(
        title: const Text('Sincronizar baralhos'),
        content: const Text(
            "Ao confirmar, seus baralhos serão sincronizados com o servidor. Deseja continuar?"),
        actions: <Widget>[
          MSButton(
            style: ElevatedButton.styleFrom(primary: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancelar'),
            child: const Text('Não', style: TextStyle(color: Colors.red)),
          ),
          MSButton(
            onPressed: () async {
              Navigator.pop(context); // Tira dialog para mostrar loading
              // showLoadingDialog();

              await _collectionCubit.syncDecks();

              // Navigator.pop(context); // Retira loading
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    showDialog<void>(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: horizontalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(
                    'Sincronizando baralhos, aguarde...',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        });
  }
}

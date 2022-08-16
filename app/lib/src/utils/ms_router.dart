import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/pages/deck_page.dart';
import 'package:memento_studio/src/pages/deck_ref_page.dart';
import 'package:memento_studio/src/pages/study_page.dart';
import 'package:memento_studio/src/state_managers.dart';

import '../pages.dart';

/// {@category Utils}
/// Rotas da aplicação
class MSRouter {
  late final GoRouter _router;
  late final _RouteRefresher _refresher;
  late final void Function() _refreshListener;

  static const homeRouteName = "home";
  static const exploreRouteName = "explore";
  static const deckRefRouteName = "deck_ref";
  static const cardListRouteName = "cardList";
  static const deckRouteName = "deck";
  static const deckCreationRouteName = "deck_creation";
  static const deckEditRouteName = "deck_edit";
  static const studyRouteName = "study";
  static const signInRouteName = "sign_in";
  static const signUpRouteName = "sign_up";
  static const myAccountRouteName = "my_account";
  // static const infoRouteName = "info";

  RouteInformationProvider get routeInformationProvider =>
      _router.routeInformationProvider;

  RouteInformationParser<Object> get routeInformationParser =>
      _router.routeInformationParser;

  RouterDelegate<Object> get routerDelegate => _router.routerDelegate;

  MSRouter(AuthCubit authCubit) {
    _refresher = _RouteRefresher(authCubit);

    Logger logger = KiwiContainer().resolve();

    _router = GoRouter(
      redirect: (state) {
        logger.i("Redirecionamento para: ${state.location}");

        return null;
      },
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          name: homeRouteName,
          builder: (_, __) => const HomePage(),
          routes: [
            GoRoute(
              path: "deck_creation",
              name: deckCreationRouteName,
              builder: (_, __) => const DeckCreationPage(),
            ),
            GoRoute(
              path: "deck/:deckId",
              name: deckRouteName,
              builder: (_, state) => DeckPage(
                deckId: state.params["deckId"]!,
              ),
              routes: [
                GoRoute(
                  path: "card_list",
                  name: cardListRouteName,
                  builder: (_, state) => CardListPage(
                    deckId: state.params["deckId"]!,
                  ),
                ),
                GoRoute(
                  path: "deck_edit",
                  name: deckEditRouteName,
                  builder: (_, state) => DeckEditPage(
                    deckId: state.params["deckId"]!,
                  ),
                ),
                GoRoute(
                  path: "study",
                  name: studyRouteName,
                  builder: (_, state) => StudyPage(
                    deckId: state.params["deckId"]!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'explore',
              name: exploreRouteName,
              builder: (_, __) => const ExplorePage(),
              routes: [
                GoRoute(
                  path: "deck_ref",
                  name: deckRefRouteName,
                  builder: (_, state) => DeckRefPage(
                    deck: state.extra as Deck,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'my_account',
              name: myAccountRouteName,
              builder: (_, __) => const MyAccountPage(),
            ),
            GoRoute(
              path: 'sign_in',
              name: signInRouteName,
              builder: (_, __) => const SignInPage(),
              routes: [
                GoRoute(
                  path: 'sign_up',
                  name: signUpRouteName,
                  builder: (_, __) => const SignUpPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    _refreshListener = () => _router.goNamed("home");

    _refresher.addListener(_refreshListener);
  }

  void dispose() {
    _refresher.removeListener(_refreshListener);
    _refresher.dispose();
    _router.dispose();
  }
}

class _RouteRefresher extends ChangeNotifier {
  StreamSubscription? _subscription;
  AuthState? _lastState;

  _RouteRefresher(AuthCubit authCubit) {
    _subscription = authCubit.stream.listen((state) {
      if (_lastState == null) {
        _lastState = state;
        return;
      }

      // Gerando uma notificação apenas se houver uma mudança
      if (_lastState is Unauthenticated && state is Authenticated ||
          _lastState is Authenticated && state is Unauthenticated) {
        notifyListeners();
      }

      _lastState = state;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();

    super.dispose();
  }
}

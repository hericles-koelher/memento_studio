import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/blocs.dart';

import '../pages.dart';

class MSRouter {
  late final GoRouter _router;
  late final _RouteRefresher _refresher;
  late final void Function() _refreshListener;

  static const homeRouteName = "home";
  static const exploreRouteName = "explore";
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
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
          routes: [
            GoRoute(
              path: 'explore',
              name: exploreRouteName,
              builder: (BuildContext context, GoRouterState state) =>
                  const ExplorePage(),
            ),
            GoRoute(
              path: 'my_account',
              name: myAccountRouteName,
              builder: (BuildContext context, GoRouterState state) =>
                  const MyAccountPage(),
            ),
            GoRoute(
              path: 'sign_in',
              name: signInRouteName,
              builder: (BuildContext context, GoRouterState state) =>
                  const SignInPage(),
              routes: [
                GoRoute(
                  path: 'sign_up',
                  name: signUpRouteName,
                  builder: (BuildContext context, GoRouterState state) =>
                      const SignUpPage(),
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

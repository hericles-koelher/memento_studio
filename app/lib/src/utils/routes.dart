import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages.dart';

abstract class MSRoutes {
  static final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
        routes: [
          GoRoute(
            path: 'explore',
            name: 'explore',
            builder: (BuildContext context, GoRouterState state) =>
                const ExplorePage(),
          ),
          GoRoute(
            path: 'my_account',
            name: 'my_account',
            builder: (BuildContext context, GoRouterState state) =>
                const MyAccountPage(),
          ),
          GoRoute(
            path: 'sign_in',
            name: 'sign_in',
            builder: (BuildContext context, GoRouterState state) =>
                const SignInPage(),
            routes: [
              GoRoute(
                path: 'sign_up',
                name: 'sign_up',
                builder: (BuildContext context, GoRouterState state) =>
                    const SignUpPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static RouteInformationProvider get routeInformationProvider =>
      _router.routeInformationProvider;

  static RouteInformationParser<Object> get routeInformationParser =>
      _router.routeInformationParser;

  static RouterDelegate<Object> get routerDelegate => _router.routerDelegate;
}

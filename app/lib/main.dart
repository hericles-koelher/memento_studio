import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/blocs.dart';
import 'package:memento_studio/src/pages.dart';
import 'package:memento_studio/src/utils/ms_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injectDependencies();

  runApp(const MementoStudio());
}

Future<void> injectDependencies() async {
  var kiwi = KiwiContainer();

  var fbApp = await Firebase.initializeApp(
    name: "Memento Studio",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  kiwi.registerInstance(AuthCubit(FirebaseAuth.instanceFor(app: fbApp)));
  kiwi.registerInstance(Logger());
}

final GoRouter _router = GoRouter(
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
        ]),
  ],
);

class MementoStudio extends StatelessWidget {
  const MementoStudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: 'Memento Studio',
      theme: MSTheme.light,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/state_managers/cubit/auth_cubit.dart';
import 'package:memento_studio/src/state_managers/cubit/deck_collection_cubit.dart';
import 'package:memento_studio/src/utils.dart';

import 'package:logging/logging.dart';

/// @nodoc
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injectDependencies();

  _setupLogging();

  runApp(const MementoStudio());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MementoStudio extends StatefulWidget {
  const MementoStudio({Key? key}) : super(key: key);

  @override
  State<MementoStudio> createState() => _MementoStudioState();
}

/// @nodoc
class _MementoStudioState extends State<MementoStudio> {
  final MSRouter _msRoutes;
  final DeckCollectionCubit _collectionCubit;

  _MementoStudioState()
      : _collectionCubit = KiwiContainer().resolve(),
        _msRoutes = MSRouter(KiwiContainer().resolve());

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: KiwiContainer().resolve<AuthCubit>(),
      listenWhen: (prev, next) =>
          prev is LogoutLoading && next is Unauthenticated ||
          prev is AuthenticationLoading && next is Authenticated,
      listener: (context, state) {
        if (state is Authenticated) {
          _collectionCubit.syncDecks();
        }
        if (state is Unauthenticated) {
          _collectionCubit.clear();
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _msRoutes.routeInformationProvider,
        routeInformationParser: _msRoutes.routeInformationParser,
        routerDelegate: _msRoutes.routerDelegate,
        title: 'Memento Studio',
        theme: MSTheme.light,
      ),
    );
  }

  @override
  void dispose() {
    _msRoutes.dispose();

    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/utils.dart';

import 'package:logging/logging.dart';

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

class _MementoStudioState extends State<MementoStudio> {
  final MSRouter _msRoutes;

  _MementoStudioState() : _msRoutes = MSRouter(KiwiContainer().resolve());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _msRoutes.routeInformationProvider,
      routeInformationParser: _msRoutes.routeInformationParser,
      routerDelegate: _msRoutes.routerDelegate,
      title: 'Memento Studio',
      theme: MSTheme.purple,
    );
  }

  @override
  void dispose() {
    _msRoutes.dispose();

    super.dispose();
  }
}

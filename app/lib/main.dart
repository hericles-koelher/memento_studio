import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injectDependencies();

  runApp(const MementoStudio());
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
      theme: MSTheme.light,
    );
  }

  @override
  void dispose() {
    _msRoutes.dispose();

    super.dispose();
  }
}

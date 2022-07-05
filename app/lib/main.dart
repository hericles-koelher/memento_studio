import 'package:flutter/material.dart';
import 'package:memento_studio/src/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await injectDependencies();

  runApp(const MementoStudio());
}

class MementoStudio extends StatelessWidget {
  const MementoStudio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: MSRoutes.routeInformationProvider,
      routeInformationParser: MSRoutes.routeInformationParser,
      routerDelegate: MSRoutes.routerDelegate,
      title: 'Memento Studio',
      theme: MSTheme.light,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/blocs.dart';
import 'package:memento_studio/src/widgets.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = KiwiContainer().resolve();

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Minha Conta"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout"),
          onPressed: () {
            authCubit.signOut();
          },
        ),
      ),
    );
  }
}

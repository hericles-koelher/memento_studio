import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/widgets.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = KiwiContainer().resolve();
    DeckCollectionCubit deckCollectionCubit = KiwiContainer().resolve();

    return Scaffold(
      drawer: const MSDrawer(),
      appBar: AppBar(
        title: const Text("Minha Conta"),
        centerTitle: true,
      ),
      body: Center(
        child: MSButton(
          child: const Text("Logout"),
          onPressed: () async {
            await deckCollectionCubit.syncDecks();

            authCubit.signOut();
          },
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/state_managers.dart';
import 'package:memento_studio/src/utils.dart';

/// {@category Widgets}
/// Drawer
class MSDrawer extends StatelessWidget {
  const MSDrawer({Key? key}) : super(key: key);

  String _generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(
        r.nextInt(256), (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: KiwiContainer().resolve<AuthCubit>(),
      builder: (context, state) {
        String username = state is Authenticated && state.user.name != null
            ? state.user.name!
            : "Usuário";

        String jdenticonString =
            state is Authenticated ? state.user.id : _generateRandomString();

        return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: MSTheme.lightPurple,
                child: DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SvgPicture.string(
                          Jdenticon.toSvg(
                            jdenticonString,
                            padding: 0.0,
                          ),
                        ),
                      ),
                      Text("Olá $username"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: MSTheme.lightPurple.withOpacity(0.2),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Meus Baralhos"),
                        leading: const Icon(Icons.home),
                        onTap: () {
                          // Esse pop é pra fechar a Drawer
                          Navigator.pop(context);
                          GoRouter.of(context).goNamed(MSRouter.homeRouteName);
                        },
                      ),
                      ListTile(
                        title: const Text("Explorar"),
                        leading: const Icon(Icons.search),
                        onTap: () {
                          // Esse pop é pra fechar a Drawer
                          Navigator.pop(context);
                          GoRouter.of(context)
                              .goNamed(MSRouter.exploreRouteName);
                        },
                      ),
                      if (state is Unauthenticated)
                        ListTile(
                          title: const Text("Autenticação"),
                          leading: const Icon(Icons.person),
                          onTap: () {
                            // Esse pop é pra fechar a Drawer
                            Navigator.pop(context);
                            GoRouter.of(context)
                                .goNamed(MSRouter.signInRouteName);
                          },
                        ),
                      if (state is Authenticated)
                        ListTile(
                          title: const Text("Minha Conta"),
                          leading: const Icon(Icons.person),
                          onTap: () {
                            // Esse pop é pra fechar a Drawer
                            Navigator.pop(context);
                            GoRouter.of(context)
                                .goNamed(MSRouter.myAccountRouteName);
                          },
                        ),
                      // const ListTile(
                      //   title: Text("Informações"),
                      //   leading: Icon(Icons.info_outline),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

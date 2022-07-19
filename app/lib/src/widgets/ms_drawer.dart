import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/blocs.dart';
import 'package:memento_studio/src/utils.dart';

class MSDrawer extends StatelessWidget {
  const MSDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: KiwiContainer().resolve<AuthCubit>(),
      builder: (context, state) {
        String username = state is Authenticated && state.user.name != null
            ? state.user.name!
            : "Usuário";

        String jdenticonString =
            state is Authenticated ? state.user.id : "default_jdenticon";

        return Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  GoRouter.of(context).goNamed(MSRouter.exploreRouteName);
                },
              ),
              if (state is Unauthenticated)
                ListTile(
                  title: const Text("Autenticação"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    // Esse pop é pra fechar a Drawer
                    Navigator.pop(context);
                    GoRouter.of(context).goNamed(MSRouter.signInRouteName);
                  },
                ),
              if (state is Authenticated)
                ListTile(
                  title: const Text("Minha Conta"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    // Esse pop é pra fechar a Drawer
                    Navigator.pop(context);
                    GoRouter.of(context).goNamed(MSRouter.myAccountRouteName);
                  },
                ),
              const ListTile(
                title: Text("Informações"),
                leading: Icon(Icons.info_outline),
              ),
            ],
          ),
        );
      },
    );
  }
}

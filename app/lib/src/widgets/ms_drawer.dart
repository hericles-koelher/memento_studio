import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/blocs.dart';

class MSDrawer extends StatelessWidget {
  const MSDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: KiwiContainer().resolve<AuthCubit>(),
      builder: (context, state) {
        String username = state is Autheticated && state.user.name != null
            ? state.user.name!
            : "Usuário";

        String jdenticonString =
            state is Autheticated ? state.user.id : "default_jdenticon";

        return Drawer(
          child: Column(
            // padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Spacer(),
                    Expanded(
                      flex: 4,
                      child: SvgPicture.string(
                        Jdenticon.toSvg(
                          jdenticonString,
                          padding: 0.0,
                        ),
                      ),
                    ),
                    // const Spacer(),
                    Text("Olá $username"),
                  ],
                ),
              ),
              ListTile(
                title: const Text("Meus Baralhos"),
                leading: const Icon(Icons.home),
                onTap: () => GoRouter.of(context).goNamed("home"),
              ),
              ListTile(
                title: const Text("Explorar"),
                leading: const Icon(Icons.search),
                onTap: () => GoRouter.of(context).goNamed("explore"),
              ),
              if (state is Unautheticated)
                ListTile(
                  title: const Text("Autenticação"),
                  leading: const Icon(Icons.person),
                  onTap: () => GoRouter.of(context).goNamed("sign_in"),
                ),
              if (state is Autheticated)
                ListTile(
                  title: Text("Minha Conta"),
                  leading: Icon(Icons.person),
                ),
              ListTile(
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

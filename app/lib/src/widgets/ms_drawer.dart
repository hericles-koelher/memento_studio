import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MSDrawer extends StatelessWidget {
  const MSDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 36),
                Text("Olá Fulano"),
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
          ListTile(
            title: Text("Autenticação"),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Informações"),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}

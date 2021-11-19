import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/auth.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 170.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondaryVariant,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'State Management',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.authOrHomeScreen);
            },
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.ordersScreen);
            },
            leading: const Icon(Icons.payments),
            title: const Text('Pedidos'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.productsScreen);
            },
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Produtos'),
          ),
          ListTile(
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.authOrHomeScreen);
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

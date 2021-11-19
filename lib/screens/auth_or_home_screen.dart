import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/auth.dart';
import 'package:flutter_minha_loja/screens/auth_screen.dart';
import 'package:flutter_minha_loja/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  const AuthOrHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outlined,
                  color: Colors.redAccent,
                  size: 48.0,
                ),
                Text('Ocorreu um erro.'),
              ],
            ),
          );
        } else {
          return auth.isAuth
              ? const ProductsOverviewScreen()
              : const AuthScreen();
        }
      },
    );
  }
}

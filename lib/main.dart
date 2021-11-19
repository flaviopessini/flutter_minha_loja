import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/auth.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/order_list.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:flutter_minha_loja/screens/auth_or_home_screen.dart';
import 'package:flutter_minha_loja/screens/cart_screen.dart';
import 'package:flutter_minha_loja/screens/orders_screen.dart';
import 'package:flutter_minha_loja/screens/product_detail_screen.dart';
import 'package:flutter_minha_loja/screens/product_form_screen.dart';
import 'package:flutter_minha_loja/screens/products_screen.dart';
import 'package:flutter_minha_loja/utils/custom_route.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          /// Auth deve ser o primeiro provider pois há dependentes da autenticação.
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          /// Depende de Auth provider.
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          /// Depende de Auth provider.
          create: (_) => OrderList(),
          update: (ctx, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
              TargetPlatform.android: CustomPageTransitionsBuilder(),
            },
          ),
        ),
        routes: {
          AppRoutes.authOrHomeScreen: (ctx) => const AuthOrHomeScreen(),
          AppRoutes.productDetailScreen: (ctx) => const ProductDetailScreen(),
          AppRoutes.cartScreen: (ctx) => const CartScreen(),
          AppRoutes.ordersScreen: (ctx) => const OrdersScreen(),
          AppRoutes.productsScreen: (ctx) => const ProductsScreen(),
          AppRoutes.productFormScreen: (ctx) => const ProductFormScreen(),
        },
      ),
    );
  }
}

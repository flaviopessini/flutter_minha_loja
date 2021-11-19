import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/app_drawer_widget.dart';
import 'package:flutter_minha_loja/components/badge_widget.dart';
import 'package:flutter_minha_loja/components/product_grid_widget.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja'),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cartScreen);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => BadgeWidget(
              value: cart.itemCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions filter) {
              // if (filter == FilterOptions.Favorite) {
              //   provider.showFavoriteOnly();
              // } else {
              //   provider.showAll();
              // }

              setState(() {
                if (filter == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawerWidget(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGridWidget(_showFavoriteOnly),
    );
  }
}

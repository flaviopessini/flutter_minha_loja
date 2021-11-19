import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/app_drawer_widget.dart';
import 'package:flutter_minha_loja/components/product_item_widget.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductList>(context);

    Future<void> _refresh(BuildContext context) {
      return Provider.of<ProductList>(context, listen: false).loadProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productFormScreen);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawerWidget(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: products.itemCount,
            itemBuilder: (BuildContext ctx, int index) =>
                ProductItemWidget(products.items[index]),
          ),
        ),
      ),
    );
  }
}

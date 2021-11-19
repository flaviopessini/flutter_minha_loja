import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/product_grid_item_widget.dart';
import 'package:flutter_minha_loja/models/product.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:provider/provider.dart';

class ProductGridWidget extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGridWidget(this.showFavoriteOnly, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: loadedProducts.length,
      itemBuilder: (BuildContext ctx, int index) =>
          ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductGridItemWidget(),
      ),
    );
  }
}

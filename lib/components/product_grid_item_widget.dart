import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/auth.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/product.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductGridItemWidget extends StatelessWidget {
  const ProductGridItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.productDetailScreen,
            arguments: product,
          );
        },
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavorite(
                    token: auth.token ?? '',
                    userId: auth.userId ?? '',
                  );
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_outline,
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Adicionado com sucesso!'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

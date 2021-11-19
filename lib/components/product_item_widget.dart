import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/exceptions/custom_http_exception.dart';
import 'package:flutter_minha_loja/models/product.dart';
import 'package:flutter_minha_loja/models/product_list.dart';
import 'package:flutter_minha_loja/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;

  const ProductItemWidget(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scafMessenger = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        // backgroundImage: NetworkImage(product.imageUrl),
        backgroundColor: Colors.white,
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: product.imageUrl,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productFormScreen,
                  arguments: product,
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (BuildContext ctx) => AlertDialog(
                    title: const Text('Excluir produto'),
                    content: const Text('Tem certeza?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(context, listen: false)
                          .removeProdut(product);
                    } on CustomHttpException catch (e) {
                      scafMessenger.showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                });
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

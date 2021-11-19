import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/cart_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget(this.cartItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: const Text('Remover'),
            content: const Text('Deseja remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.onError,
          size: 32.0,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text(
                  NumberFormat.compactSimpleCurrency(name: '', locale: 'PT-BR')
                      .format(cartItem.price),
                ),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text(
              'Total: ${NumberFormat.compactSimpleCurrency(locale: 'PT-BR').format(cartItem.price * cartItem.quantity)}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}

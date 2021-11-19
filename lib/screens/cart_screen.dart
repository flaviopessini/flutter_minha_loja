import 'package:flutter/material.dart';
import 'package:flutter_minha_loja/components/cart_item_widget.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/order_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      NumberFormat.compactSimpleCurrency(locale: 'PT-BR')
                          .format(cart.totalAmount),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6?.color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) => CartItemWidget(items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  final Cart cart;

  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemCount == 0
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    await Provider.of<OrderList>(context, listen: false)
                        .addOrder(widget.cart);
                    widget.cart.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Pedido finalizado!'),
                        action: SnackBarAction(
                          label: 'Fechar',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                    setState(() => _isLoading = false);
                  },
            child: const Text('Comprar'),
          );
  }
}

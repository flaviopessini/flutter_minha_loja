import 'package:flutter_minha_loja/models/cart_item.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  const Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

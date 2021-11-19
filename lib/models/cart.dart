import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_minha_loja/models/cart_item.dart';
import 'package:flutter_minha_loja/models/product.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  int get itemCount => _items.length;

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (item) {
        return CartItem(
          id: item.id,
          name: item.name,
          price: item.price,
          productId: item.productId,
          quantity: item.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          quantity: 1,
          price: product.price,
        ),
      );
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(productId, (item) {
        return CartItem(
          id: item.id,
          name: item.name,
          price: item.price,
          productId: item.productId,
          quantity: item.quantity - 1,
        );
      });
    }
    notifyListeners();
  }
}

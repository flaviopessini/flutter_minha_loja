import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_minha_loja/models/cart.dart';
import 'package:flutter_minha_loja/models/cart_item.dart';
import 'package:flutter_minha_loja/models/order.dart';
import 'package:flutter_minha_loja/utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items;

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemCount => _items.length;

  List<Order> get items => [..._items];

  Future<void> addOrder(Cart cart) async {
    final currentDate = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': currentDate.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: currentDate,
      ),
    );

    notifyListeners();
    return Future.value();
  }

  Future<void> loadOrders() async {
    List<Order> orders = [];

    final response = await http
        .get(Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'));

    if (response.body.isEmpty || response.body == 'null') {
      return Future.value();
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((key, value) {
      orders.add(Order(
        id: key,
        date: DateTime.parse(value['date']),
        total: value['total'],
        products: (value['products'] as List<dynamic>).map((item) {
          return CartItem(
            id: item['id'],
            productId: item['productId'],
            name: item['name'],
            quantity: item['quantity'],
            price: item['price'],
          );
        }).toList(),
      ));
    });

    _items = orders.reversed.toList();
    notifyListeners();
    return Future.value();
  }
}

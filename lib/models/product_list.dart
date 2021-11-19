import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_minha_loja/exceptions/custom_http_exception.dart';
import 'package:flutter_minha_loja/models/product.dart';
import 'package:flutter_minha_loja/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  final List<Product> _items;

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  int get itemCount => _items.length;

  List<Product> get items => [..._items];

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'),
      body: jsonEncode({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'imageUrl': product.imageUrl,
      }),
    );

    if (response.statusCode == 201 && response.body.isNotEmpty) {
      final id = jsonDecode(response.body)['name'];

      _items.add(Product(
        id: id,
        name: product.name,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      ));

      notifyListeners();
    }

    return Future.value();
  }

  Future<void> loadProducts() async {
    final response = await http
        .get(Uri.parse('${Constants.productBaseUrl}.json?auth=$_token'));

    if (response.body.isEmpty || response.body == 'null') {
      return Future.value();
    }

    _items.clear();

    final favResponse = await http.get(
      Uri.parse('${Constants.userFavoritesUrl}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((key, value) {
      final isFavorite = favData[key] ?? false;
      _items.add(Product(
        id: key,
        name: value['name'],
        description: value['description'],
        price: value['price'],
        imageUrl: value['imageUrl'],
        isFavorite: isFavorite,
      ));
    });

    notifyListeners();
    return Future.value();
  }

  Future<void> removeProdut(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      final removed = _items[index];

      // Exclusão otimista.
      _items.removeAt(index);
      notifyListeners();

      final response = await http.delete(Uri.parse(
          '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'));

      if (response.statusCode >= 400) {
        // Restaura o item na lista.
        _items.insert(index, removed);
        notifyListeners();
        throw CustomHttpException(
            'Não foi possível excluir o item.', response.statusCode);
      }
    }

    return Future.value();
  }

  Future<void> saveProduct(Map<String, dynamic> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'].toString() : Random().nextDouble.toString(),
      name: data['name'].toString(),
      description: data['description'].toString(),
      price: data['price'] as double,
      imageUrl: data['imageUrl'].toString(),
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.productBaseUrl}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }
}

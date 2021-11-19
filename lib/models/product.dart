import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_minha_loja/utils/constants.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  /// Alternar favorito.
  Future<void> toggleFavorite(
      {required String token, required String userId}) async {
    try {
      /// Alterna favorito na lista.
      _toggleFavorite();

      final response = await http.put(
        Uri.parse('${Constants.userFavoritesUrl}/$userId/$id.json?auth=$token'),
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        /// Se falhar, reverte o estado anterior na lista.
        _toggleFavorite();
      }
    } on Exception catch (_) {
      /// Reverte a modificação.
      _toggleFavorite();
    }

    return Future.value();
  }

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

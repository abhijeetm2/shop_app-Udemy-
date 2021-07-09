import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});

  Future<void> toggleFavouriteStatus(String? authToken, String? userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/userFavourite/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode(
            isFavourite,
          ));

      if (response.statusCode >= 400) {
        //...
        _setFavoldValue(oldStatus);
      }
    } catch (e) {
      _setFavoldValue(oldStatus);
      print(e);
    }
  }

  void _setFavoldValue(bool oldStatus) {
    isFavourite = oldStatus;
    notifyListeners();
  }
}

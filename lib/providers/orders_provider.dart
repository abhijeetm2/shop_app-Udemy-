import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/model/cart.dart';
import 'package:shop_app/model/order.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  final String? authToken;
  final String? userId;

  OrdersProvider(this._orders, this.userId, this.authToken);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchOrdersDetails() async {
    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    print(json.decode(response.body));

    final List<Order> loadOrders = [];
    final extracxtedData = json.decode(response.body) as Map<String, dynamic>;

    if (extracxtedData.isEmpty) {
      return;
    }

    extracxtedData.forEach((orderId, orderData) {
      loadOrders.add(Order(
        id: orderId,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>)
            .map((item) => Cart(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ))
            .toList(),
        dateTime: DateTime.parse(orderData['dateTime']),
      ));
    });
    _orders = loadOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cardProducts, double totalAmount) async {
    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final dateTime = DateTime.now();

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        //...
        'amount': totalAmount,
        'dateTime': dateTime.toIso8601String(),
        'products': cardProducts
            .map((cp) => {
                  //...
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      Order(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          products: cardProducts,
          dateTime: dateTime),
    );
    notifyListeners();
  }
}

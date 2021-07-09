import 'package:flutter/foundation.dart';
import 'package:shop_app/model/cart.dart';



class CartProvider with ChangeNotifier {
  Map<String, Cart>? _items = {};

  Map<String, Cart> get Items {
    return {..._items!};
  }

  int get itemCount {
    if (_items == null) {
      return 0;
    }
    return _items!.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cart) {
      total = total + cart.price * cart.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items!.containsKey(productId)) {
      //...change entry and increment quantity
      _items!.update(
          productId,
          (existing) => Cart(
                id: existing.id,
                title: existing.title,
                price: existing.price,
                quantity: existing.quantity + 1,
              ));
    } else {
      //... add new entry in cart
      _items!.putIfAbsent(
          productId,
          () => Cart(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items!.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    /* if (!_items!.containsKey(productId)) { we don't need this condition because we using nullsoft
      return;
    }*/
    if (_items![productId]!.quantity > 1) {
      //..check the quantity before remove product
      _items!.update(
          productId,
          (existingCartItem) => Cart(
                id: existingCartItem.id,
                title: existingCartItem.title,
                quantity: existingCartItem.quantity - 1,
                price: existingCartItem.price,
              ));
    } else {
      //...if there is no quantity then delete product
      _items!.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items!.clear();
    notifyListeners();
  }
}

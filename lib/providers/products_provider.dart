import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // as http to avoid name clashes

import 'package:flutter/cupertino.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/widgets/error_dialog.dart';

class ProductsProvider with ChangeNotifier {
  //with is knows as mixin, merging the properties and methods in existing class

  List<Product> _items = [
    /*  Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this._items, this.userId);

  List<Product> get showAllItems {
    return [..._items];
  }

  List<Product> get favouritesItems {
    return [..._items.where((product) => product.isFavourite).toList()];
  }

  Product findByid(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creater"&equalTo="$userId"' : '';

    final productUrl =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(productUrl));
      print(json.decode(response.body));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }

      final userFavouriteUrl =
          'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/userFavourite/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(Uri.parse(userFavouriteUrl));

      final favouriteDate = json.decode(favouriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.insert(
            0,
            Product(
              id: prodId,
              price: prodData['price'],
              title: prodData['title'],
              description: prodData['description'],
              isFavourite: favouriteDate == null
                  ? false
                  : favouriteDate[prodId] ?? false,
              imageUrl: prodData['imageUrl'],
            ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<void> addProduct(Product product, BuildContext context) async {
    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'creater': userId
            },
          ));

      print(json.decode(response.body)); // we get crypted key from firebase

      //... after added on firebase we getting success response then add in screen
      final newProduct = Product(
        //use firebase id insted of datetime as id
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); //at the start of the list
      notifyListeners();
    } catch (e) {
      print(e);
      print('$e exception');
      return NetworkAlertDialog.showErrorDialog(context);
    }

    /*  final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); //at the start of the list
    notifyListeners();*/
  }

  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((prod) {
      return prod.id == id;
    });

    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));

    _items[prodIndex] = product;
    notifyListeners();

    /*  for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        _items[i] = product;
        notifyListeners();
      }
    }*/
    //...
  }

  Future<void> deleteProduct(String id, ScaffoldMessengerState scaffold) async {
    // like notifyDataset() at java
    final url =
        'https://flutter-shop-app-4c6fb-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((prod) {
      return prod.id == id;
    });
    var existingProduct;

    await http.delete(Uri.parse(url)).then((response) {
      //...
      if (response.statusCode == 200) {
        existingProduct = _items[existingProductIndex];
        _items.removeAt(existingProductIndex);
        notifyListeners();
        scaffold.showSnackBar(SnackBar(content: Text('Item deleted')));
      } else {
        scaffold.showSnackBar(SnackBar(content: Text('Something went wrong')));
      }
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
  }
}

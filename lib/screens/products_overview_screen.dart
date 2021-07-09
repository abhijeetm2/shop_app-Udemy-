import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/adapter/listviews/product_gridview.dart';
import 'package:shop_app/navigation_drawer/app_drawer.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:http/http.dart' as http;

enum FilterOptions {
  Favourite,
  All,
}

class ProductsOverviewsScreen extends StatefulWidget {
  @override
  _ProductsOverviewsScreenState createState() =>
      _ProductsOverviewsScreenState();
}

class _ProductsOverviewsScreenState extends State<ProductsOverviewsScreen> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = true;

  @override
  void initState() {
    //Provider.of<ProductsProvider>(context).fetchProducts(); //context related code won't work
    /*Future.delayed(Duration.zero).then((_) { its kind a hack
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    });*/
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isLoading = false;
    _isInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              print('$selectedValue');
              setState(() {
                if (selectedValue == FilterOptions.Favourite) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FilterOptions.Favourite),
                PopupMenuItem(
                    child: Text('Show All'), value: FilterOptions.All),
              ];
            },
            icon: Icon(Icons.more_vert),
          ),
          Container(
            margin: EdgeInsets.only(right: 12, top: 4),
            width: 30,
            height: 30,
            child: Consumer<CartProvider>(
              builder: (ctx, cart, child) => Badge(
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                cartData.itemCount.toString(),
                Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGridList(_showOnlyFavourites),
      drawer: AppDrawer(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/model/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,
        listen: false); //counsumer widget is alternative of provider

    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailsScreen.routeName, arguments: product.id);
        },
        child: Hero(
          tag: product.id, //it could be any thing but unique
          child: FadeInImage(
            placeholder: AssetImage('assets/images/product_placeholder.png'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: Consumer<Product>(
          //this will rebuild only nested child product
          builder: (ctx, product, child) => IconButton(
            icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              product.toggleFavouriteStatus(authData.token, authData.userId);
            },
          ),
        ),
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Added item to cart'),
              action: SnackBarAction(
                onPressed: () {
                  cart.removeSingleItem(product.id);
                },
                label: 'UNDO',
              ),
              duration: Duration(seconds: 2),
            ));
          },
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

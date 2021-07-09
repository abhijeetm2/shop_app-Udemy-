import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final _listProducts = Provider.of<ProductsProvider>(context, listen: false)
        .findByid(productId);

    return Scaffold(
      /*  appBar: AppBar(
        title: Text(_listProducts.title),
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.35,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_listProducts.title),
              background: Hero(
                tag: _listProducts.id,
                child: Image.network(_listProducts.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text(
                '\$${_listProducts.price}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(_listProducts.description,
                    textAlign: TextAlign.center, softWrap: true),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.83,
              )
            ]),
          )
        ],
      ),
    );
  }
}

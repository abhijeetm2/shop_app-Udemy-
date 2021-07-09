import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/adapter/items/product_item.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductGridList extends StatelessWidget {
  final bool _showFavs;

  ProductGridList(this._showFavs);

  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        _showFavs ? productsData.favouritesItems : productsData.showAllItems;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          //to avoid product product was used after being disposed use .value
          value: products[i],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}

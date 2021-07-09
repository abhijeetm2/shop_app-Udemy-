import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/adapter/items/user_product_item.dart';
import 'package:shop_app/navigation_drawer/app_drawer.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('UserProductScreen : running');
    // final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return _refreshProduct(context);
                    },
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                UserProductItem(
                                    productData.showAllItems[index].id,
                                    productData.showAllItems[index].title,
                                    productData.showAllItems[index].imageUrl),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: productData.showAllItems.length,
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}

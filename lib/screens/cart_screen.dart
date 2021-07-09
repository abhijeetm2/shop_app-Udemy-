import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/adapter/items/cart_item.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  order_button(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            //expanded widget for listview to take as much as space
            child: ListView.builder(
              itemCount: cart.Items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.Items.values.toList()[i].id,
                  cart.Items.keys.toList()[i],
                  cart.Items.values.toList()[i].price,
                  cart.Items.values.toList()[i].quantity,
                  cart.Items.values.toList()[i].title),
            ),
          ),
        ],
      ),
    );
  }
}

class order_button extends StatefulWidget {
  const order_button({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _order_buttonState createState() => _order_buttonState();
}

class _order_buttonState extends State<order_button> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<OrdersProvider>(context, listen: false)
                    .addOrder(widget.cart.Items.values.toList(),
                        widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'ORDER NOW',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ));
  }
}

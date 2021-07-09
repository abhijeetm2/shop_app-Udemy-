import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../adapter/items/order_item.dart';
import '../navigation_drawer/app_drawer.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _orderFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<OrdersProvider>(context, listen: false)
        .fetchOrdersDetails();
  }

  @override
  void initState() {
    // this is the apporach if we want build execute again and again
    _orderFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  final orderData = Provider.of<OrdersProvider>(context); to avoid infinite loop use consumer
    print('building orders');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        /* when ever use futurebuilder use consumer along with it */
        /* with the help of future builder we don't need to convert in stateful widget*/
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              //... error handling stuff
              return Center(child: Text('An error occured!'));
            } else {
              //... no error then show result
              return Consumer<OrdersProvider>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) {
                      return OrderItem(orderData.orders[i]);
                    },
                  );
                },
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

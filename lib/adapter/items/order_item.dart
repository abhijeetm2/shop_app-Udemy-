import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/model/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ),
            ),
            //if (_expanded) because of animated container
            AnimatedContainer(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 16.0 + 20,
                      mediaQuery.height * 0.15)
                  : 0,
              duration: Duration(milliseconds: 300),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

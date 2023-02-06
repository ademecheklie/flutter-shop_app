

import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  static const routeName = 'order-item';
  OrderItem(this.order);
  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle:
              Text(DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
              icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expand = !_expand;
                  
                }
                );
              }
              ),
        ),
        if (_expand)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: min(widget.order.products.length * 20.0 + 10, 100),
            child: ListView(
                children: widget.order.products
                    .map((prod) =>
                     Row(
        
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod.title,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${prod.quantity}X \$${prod.price.toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )
                            ],
                          ),
                        )
                    .toList()),
          )
      ]),
    );
  }
}

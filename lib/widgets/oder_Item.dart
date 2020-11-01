import 'package:flutter/material.dart';
import '../providers/order.dart' as oi;
import 'package:intl/intl.dart';
import 'dart:math';
class OrderItem extends StatefulWidget {
  final oi.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expended=false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(DateFormat('dd mm yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: !expended ? Icon(Icons.expand_more): Icon(Icons.expand_less),
              onPressed: (){
                setState(() {
                  expended=!expended;
                });
              },
            ),
          ),
          if(expended) Container(
            padding: EdgeInsets.all(20),
            height: min(widget.order.cardItem.length*20.0+50,180),
            child: ListView.builder(itemBuilder: (ctx,i)=>Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.order.cardItem[i].title),
                  Text('${widget.order.cardItem[i].price}'),
                ],
              ),
              itemCount: widget.order.cardItem.length,
            ),

          ),
        ],
      ),
    );
  }
}

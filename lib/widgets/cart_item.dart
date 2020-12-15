import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final String image;
  final int quantity;
  final String title;

  CartItem(
  {
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.image,
    this.title,
  }
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int count = 1;
  @override
  void initState() {
    // TODO: implement initState
    count=widget.quantity;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Text("Delete", style: TextStyle(color: Colors.white),),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        // margin: EdgeInsets.symmetric(
        //   horizontal: 15,
        //   vertical: 4,
        // ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are You Sure!'),
            content: Text('Do you want to delete item from cart'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.2
                  ),
                ),
            ),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "100 grm",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            child: Consumer<Cart>(
              builder: (context,cart, ch)=>Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Rs: ${cart.items[widget.productId].price*cart.items[widget.productId].quantity}",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16),),
                 SizedBox(
                   height: 20,
                 ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.16),
                          blurRadius: 6,
                          offset: Offset(0,3),
                        )]
                    ),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              Icons.remove,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: () {
                            if (cart.items[widget.productId].quantity!=1)
                              cart.removeSingleItem(widget.productId);
                            // if (count != 1)
                            //   setState(() {
                            //     count -= 1;
                            //   });
                          },
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          //padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Text(
                            cart.items[widget.productId].quantity.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: () {
                            cart.addItem(widget.productId, widget.price, widget.title,widget.image);
                            // setState(() {
                            //   count += 1;
                            // });
                          },
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Card(
// margin: EdgeInsets.symmetric(
// horizontal: 15,
// vertical: 4,
// ),
// child: Padding(
// padding: EdgeInsets.all(8),
// child: ListTile(
// leading: CircleAvatar(
// child: Padding(
// padding: EdgeInsets.all(5),
// child: FittedBox(
// child: Text('\$$price'),
// ),
// ),
// ),
// title: Text(title),
// subtitle: Text('Total: \$${(price * quantity)}'),
// trailing: Column(
// children: [
// Text('$quantity x'),
// Container(
// child: Text("Hellp"),
// ),
// ],
// ),
// ),
// ),
// ),

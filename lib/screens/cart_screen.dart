import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/providers/global_variables.dart';

import 'package:softwareengineering/screens/checkout_screen.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';


class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Provider.of<GlobalVariables>(context).isCheckout ? CheckOutScreen() :Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              price: cart.items.values.toList()[i].price,
              quantity: cart.items.values.toList()[i].quantity,
              title: cart.items.values.toList()[i].title,
              image: cart.items.values.toList()[i].image,
            ),
          ),
          Positioned(
            bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        cart.clear();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15,),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xFFFE7262),
                          ),
                          // color: Color(0xFFFE7262),
                        ),
                        child: Text("CLEAR", style: TextStyle(color: Color(0xFFFE7262),fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: cart.itemCount==0 ? null :()=>Provider.of<GlobalVariables>(context,listen: false).changeCheckout(),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: cart.itemCount==0? Color(0xFFFE7262).withOpacity(0.45) : Color(0xFFFE7262),
                        ),
                        child: Text("CHECKOUT", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ],
      );
  }
}



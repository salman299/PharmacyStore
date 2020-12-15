import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/providers/global_variables.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import 'package:softwareengineering/screens/address_screen.dart';

import '../providers/cart.dart';
import '../providers/order.dart';
class CheckOutScreen extends StatelessWidget {
  static const routeName = '/checkout';
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context,listen: false);
    return Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0,1),
                  )]
                ),
                child: ClipPath(
                  clipper: MultipleRoundedCurveClipper(
                  ),
                  child: Consumer<Cart>(
                    builder:(ctx,cart,ch)=> Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      //color: Colors.grey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          tile("Subtotal", "Rs. "+ cart.totalAmount.toString()),
                          tile("Delivery", "Rs. 50"),
                          tile("Discount", "Rs. 0"),
                          tile("Service Fees", "Rs. 0"),
                          tile("Sales Tax", "Rs. 0"),
                          Divider(color: Colors.black26,),
                          tile("Total", "Rs "+(cart.totalAmount+50).toString()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text("Pre Order Details", style: TextStyle(fontWeight: FontWeight.w500),textAlign: TextAlign.left,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                //color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 6,
                      offset: Offset(0,3),
                    )]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: ()=>Navigator.of(context).pushNamed(AddressScreen.routeName),
                        child: Consumer<UserInfo>(
                          builder: (ctx,userInfo,ch)=>tileDown("Delivery to", userInfo.myAddress==null?"No Address." : userInfo.myAddress.location.substring(0,10)+"...")
                        ),
                    ),
                    tileDown("Delivery Time", "45 min"),
                    tileDown("Delivery Method", "Cash on Delivery"),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
              right: 15,
              left: 15,
              child:OrderButton(cart: cart) )
        ],
      );
  }
}

Widget tile(String title, String value) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    ),
  );
}

Widget tileDown(String title, String value) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(value),
            Icon(Icons.keyboard_arrow_right_sharp)
          ],
        ),
      ],
    ),
  );
}


class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _address = "";
  var _phoneNo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey("None"),
      direction: DismissDirection.endToStart,
      background: _isLoading ? Center(child: CircularProgressIndicator()): Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.greenAccent,
        ),
        child: Text("Slide To Order", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
      ),
      confirmDismiss: (direction) async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Order>(context, listen: false).addItem(
            widget.cart.items.values.toList(),
            _address,
            _phoneNo,
            widget.cart.totalAmount);
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
        Provider.of<GlobalVariables>(context,listen:false).changeCheckout();
        return true;
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: MediaQuery.of(context).size.width-30,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xFFFE7262),
          ),
          child: _isLoading ? CircularProgressIndicator() : Text("Slide To Order", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }
}
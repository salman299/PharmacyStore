import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/order.dart';
import '../providers/auth.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                    cart.items.values.toList()[i].title,
                  ),
            ),
          )
        ],
      ),
    );
  }
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
  var _isLoading=false;
  var _address="";
  var _phoneNo="";
  @override
  void initState() {
    // TODO: implement initState
    _address=Provider.of<UserInfo>(context,listen: false).address;
    _phoneNo=Provider.of<UserInfo>(context,listen: false).phoneNo;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator():Text('ORDER NOW'),
      onPressed:(widget.cart.totalAmount<=0 || _isLoading)? null : () async {
        bool _isLoaded=false;
       // print(cart.items.length);
        await showDialog(
            context: context,
          builder: (BuildContext context){
              return SingleChildScrollView(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text("Location Information"),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: _address,
                            decoration: InputDecoration(labelText: "Your address"),
                            onSaved: (val)=>_address=val,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Address.';
                              }
                              else if (value.length<=10 || value.length>=100){
                                return "Invalid Address";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: _phoneNo,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Your phoneNo"),
                            onSaved: (val)=>_phoneNo=val,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Number.';
                              }
                              else if (value.length<11)
                                return 'Invalid Number';
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text("Save Info and Confirm"),
                            color: Theme.of(context).primaryColor,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).primaryColorLight,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                {
                                  _formKey.currentState.save();
                                  _isLoaded=true;
                                  await Provider.of<UserInfo>(context,listen: false).setInfo(_address,_phoneNo);
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textColor: Theme.of(context).primaryColorLight,
                            color: Theme.of(context).primaryColor,
                            child: Text("Confirm"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                {
                                  _formKey.currentState.save();
                                  _isLoaded=true;
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
          }
        );
        if (_isLoaded)
          {
            setState(() {
              _isLoading=true;
            });
            await Provider.of<Order>(context, listen: false).addItem(
                widget.cart.items.values.toList(), _address ,_phoneNo,widget.cart.totalAmount);
            setState(() {
              _isLoading=false;
            });
            widget.cart.clear();
          }
        },
      textColor: Theme.of(context).primaryColor,
    );
  }
}

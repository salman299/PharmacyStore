import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/custom_icons_icons.dart';
import 'package:softwareengineering/screens/order_screen.dart';
import 'package:softwareengineering/screens/user_product_screen.dart';
import '../providers/auth.dart';
class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userId=Provider.of<Auth>(context,listen: false).userActualId;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15,right: 15,bottom: 10,top: 20),
              child: Text("Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700),)
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 0.2
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
             leading: CircleAvatar(
               child: Text("AS",style: TextStyle(color: Colors.black),),
               backgroundColor: Theme.of(context).accentColor.withOpacity(0.50),
             ),
             title: Text(userId),
              subtitle: Text("0331-2838176"),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
            ),

          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 0.2
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 15,left: 20),
              leading: Icon(
                CustomIcons.filter,
              ),
              title: Text(
                'Product Management',
              ),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              onTap: (){
                Navigator.of(context).pushNamed(UserProductScreen.routeName);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 0.2
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 15,left: 20),
              leading: Icon(
                CustomIcons.shopping_bag__1_,
              ),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              title: Text(
                'Order',
              ),
              onTap: (){
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 0.2
                ),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 15,left: 20),
              leading: Icon(
                CustomIcons.logout__1_,
              ),
              trailing: Icon(Icons.keyboard_arrow_right_sharp),
              title: Text(
                'Logout',
                //style: _style,
              ),
              onTap: (){
                Provider.of<Auth>(context, listen: false).signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

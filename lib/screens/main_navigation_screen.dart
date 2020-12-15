/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/providers/cart.dart';
import 'package:softwareengineering/providers/global_variables.dart';
import 'package:softwareengineering/screens/accout_screen.dart';
import 'package:softwareengineering/widgets/badge.dart';
import '../screens/products_overview_screen.dart';

import '../custom_icons_icons.dart';
import '../screens/cart_screen.dart';
import 'address_screen.dart';
import '../providers/userInfo.dart';

/// This is the stateful widget that the main application instantiates.
class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({Key key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}


/// This is the private State class that goes with MyStatefulWidget.
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    ProductsOverviewScreen(isFavourite: false,),
    ProductsOverviewScreen(isFavourite: true,),
    AccountScreen(),
    CartScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final myAddress=Provider.of<UserInfo>(context,listen: false).myAddress;
    return Scaffold(
     // backgroundColor: Colors.black,
      appBar: _selectedIndex==2? null: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFFf6f5f5),
        leading: _selectedIndex!=3 ? null:  Consumer<GlobalVariables>(
          builder: (ctx,gv, ch)=> gv.isCheckout ? IconButton(icon: Icon(Icons.clear,color: Theme.of(context).accentColor,), onPressed: ()=> gv.changeCheckout()): Container() ),
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AddressScreen.routeName);
          },
          child: Column(
            children: [
              Text(
                "DELIVER ASAP TO",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w300),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<UserInfo>(
                    builder: (ctx,userInfo, ch)=>Text(
                      userInfo.myAddress==null? "No Address Found": userInfo.myAddress.location,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
          boxShadow: [BoxShadow(
            offset: Offset(0,6),
            blurRadius: 22,
            color: Colors.black.withOpacity(0.16),
          )],
        ),
        child: ClipRRect(
          borderRadius:  BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 5,
            //backgroundColor: Colors.white,
            items:  <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.home__1_),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.heart),
                label: 'Liked',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.user3),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Consumer<Cart>(
                    builder: (ctx,cart,ch)=>Badge(child: ch,value: cart.itemCount.toString(),),
                  child: Icon(CustomIcons.shopping_bag),
                ),//Icon(CustomIcons.back),
                label: 'Cart',
              ),
            ],
            //unselectedItemColor: Colors.black.withOpacity(0.30),
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).accentColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}



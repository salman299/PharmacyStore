import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/screens/search.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import 'dart:async';

enum FilterOptions {
  Favorites,
  All,
  SortByName,
  SortByPrice0_9,
  SortByPrice9_0,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavorites = false;
  var selectedValue=FilterOptions.All;
  Future<bool> _selectCatagory(BuildContext context) async{
    if (selectedValue == FilterOptions.Favorites || selectedValue==FilterOptions.All)
      await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    else if (selectedValue==FilterOptions.SortByName)
      await Provider.of<Products>(context,listen: false).fetchAndSetProducts(sortType: "title");
    else if (selectedValue==FilterOptions.SortByPrice0_9)
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(sortType: "price", desc: false);
    else
      await Provider.of<Products>(context,listen: false).fetchAndSetProducts(sortType: "price",desc: true);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Pharmacy',style: TextStyle(color: Theme.of(context).primaryColor),),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu,color:  Color(0xFFFE7262),),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        actions: <Widget>[
//           Container(
//             margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
//             //padding: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//               boxShadow: [BoxShadow(
//                 color: Colors.black.withOpacity(0.16),
//                 offset: Offset(0,3),
//                 blurRadius: 6,
//               )]
//             ),
//             child:  Consumer<Cart>(
//               builder: (_, cart, ch) =>
//                   Badge(
//                     color: Colors.white,
//                     child: ch,
//                     value: cart.itemCount.toString(),
//                   ),
//               child: IconButton(
//                 icon: Icon(
//                     Icons.add_shopping_cart,color: Theme.of(context).primaryColor
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(CartScreen.routeName);
//                 },
//               ),
//             ),
//
// //            IconButton(
// //              icon: Icon(Icons.add_shopping_cart,color: Theme.of(context).primaryColor,),
// //              onPressed: (){
// //                Navigator.of(context).pushNamed(Search.routeName);
// //              },
// //            ),
//           ),

//          PopupMenuButton(
//            onSelected: (FilterOptions selectedValue) {
//              print(selectedValue);
//              setState(() {
//                if (selectedValue == FilterOptions.Favorites)
//                  _showOnlyFavorites = true;
//                else if (selectedValue==FilterOptions.All)
//                  _showOnlyFavorites = false;
//                this.selectedValue=selectedValue;
//              });
//            },
//            icon: Icon(
//              Icons.more_vert,
//            ),
//            itemBuilder: (_) =>
//            [
//              PopupMenuItem(
//                child: Text('Only Favorites'),
//                value: FilterOptions.Favorites,
//              ),
//              PopupMenuItem(
//                child: Text('Show All'),
//                value: FilterOptions.All,
//              ),
//              PopupMenuItem(
//                child: Text('Sort by Name'),
//                value: FilterOptions.SortByName,
//              ),
//              PopupMenuItem(
//                child: Text('Sort by Price (0-9)'),
//                value: FilterOptions.SortByPrice0_9,
//              ),
//              PopupMenuItem(
//                child: Text('Sort by Price (9-0)'),
//                value: FilterOptions.SortByPrice9_0,
//              ),
//            ],
//          ),
        ],
      ),

      body: FutureBuilder(
        future: _selectCatagory(context),
        builder: (context, snap) =>
        snap.connectionState == ConnectionState.waiting ? Center(
          child: CircularProgressIndicator(),) : Column(
          mainAxisSize: MainAxisSize.min,
            children: <Widget>[
//              Row(
//                children: <Widget>[
//                  Icon(Icons.search,)
//                ],
//              ),
              Expanded(
                child: ProductsGrid(
                  _showOnlyFavorites),
              ),
            ],
          ),
      ),
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Theme.of(context).primaryColor,
//        child:
//
//        Consumer<Cart>(
//            builder: (_, cart, ch) =>
//                Badge(
//                  child: ch,
//                  value: cart.itemCount.toString(),
//                ),
//            child: IconButton(
//              icon: Icon(
//                Icons.shopping_cart,
//              ),
//              onPressed: () {
//                Navigator.of(context).pushNamed(CartScreen.routeName);
//              },
//            ),
//          ),
//      ),
      drawer: AppDrawer(),);
  }
}
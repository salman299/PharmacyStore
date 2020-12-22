import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/custom_icons_icons.dart';


import '../widgets/products_grid.dart';

import '../providers/products.dart';
import '../providers/userInfo.dart';
import 'dart:async';

enum FilterOptions {
  Favorites,
  All,
  SortByName,
  SortByPrice0_9,
  SortByPrice9_0,
}

class ProductsOverviewScreen extends StatefulWidget {
  final isFavourite;

  ProductsOverviewScreen({this.isFavourite});

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  FocusNode _focus = new FocusNode();

  //var _showOnlyFavorites = false;
  bool _focusVal = false;
  var selectedValue = FilterOptions.SortByName;
  var searchKeyWord = TextEditingController();
  bool check = false;

  Future<bool> _selectCatagory(BuildContext context) async {
    if (_focus.hasFocus == true && (searchKeyWord.text.length == 0 || !check))
      return true;
    if (searchKeyWord.text.length >= 3)
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
          searchKeyword: searchKeyWord.text);
    // else if (selectedValue == FilterOptions.Favorites || selectedValue==FilterOptions.All)
    //   await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    else if (selectedValue == FilterOptions.SortByName) {
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
          sortType: "title");
      print("Heelo");
      await Provider.of<UserInfo>(context, listen: false).fetchAndSetAddress();
    }
    else if (selectedValue == FilterOptions.SortByPrice0_9)
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
          sortType: "price", desc: false);
    else
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
          sortType: "price", desc: true);
    return true;
  }

  void _onFocusChange() {
    print("heeekkekek");
    print("Focus: " + _focus.hasFocus.toString());
  }


  @override
  void setState(fn) {
    // TODO: implement setState
    _focus.addListener(_onFocusChange);
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFf6f5f5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  focusNode: _focus,
                  controller: searchKeyWord,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    prefixIcon: Icon(
                      Icons.search, color: Colors.black.withOpacity(0.40),),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search",
                    suffixIcon: !_focus.hasFocus ? null : IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          searchKeyWord.clear();
                        }),
                    //filled: true,
                    //fillColor: Color(0xFFf6f5f5),
                  ),
                  onChanged: (val) {
                    if (val.length >= 3)
                      setState(() {
                        check = true;
                      });
                    else if (val.length == 2 && check == true) {
                      setState(() {
                        check = false;
                      });
                    }
                  },
                ),
              ),
            ),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                print(selectedValue);
                setState(() {
                  // if (selectedValue == FilterOptions.Favorites)
                  //   _showOnlyFavorites = true;
                  // else if (selectedValue==FilterOptions.All)
                  //   _showOnlyFavorites = false;
                  this.selectedValue = selectedValue;
                });
              },
              icon: Icon(
                CustomIcons.filter, color: Colors.black.withOpacity(0.5),),
              itemBuilder: (_) =>
              [
                // PopupMenuItem(
                //   child: Text('Only Favorites'),
                //   value: FilterOptions.Favorites,
                // ),
                // PopupMenuItem(
                //   child: Text('Show All'),
                //   value: FilterOptions.All,
                // ),
                PopupMenuItem(
                  child: Text('Sort by Name'),
                  value: FilterOptions.SortByName,
                ),
                PopupMenuItem(
                  child: Text('Sort by Price (0-9)'),
                  value: FilterOptions.SortByPrice0_9,
                ),
                PopupMenuItem(
                  child: Text('Sort by Price (9-0)'),
                  value: FilterOptions.SortByPrice9_0,
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: 15),
            //     child: GestureDetector(onTap: (){}, child: Icon(CustomIcons.filter,color: Colors.black.withOpacity(0.5),),)
            // )
          ],
        ),
        FutureBuilder(
          future: _selectCatagory(context),
          builder: (context, snap) =>
          snap.connectionState == ConnectionState.waiting ? Center(
            child: CircularProgressIndicator(),) : Expanded(
            child: ProductsGrid(
                widget.isFavourite),
          ),
        ),
      ],
    );
  }
}
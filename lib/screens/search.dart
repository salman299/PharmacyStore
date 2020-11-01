import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import 'package:softwareengineering/widgets/products_grid.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/product_item.dart';

class Search extends StatelessWidget {
  static const routeName = '/search';
  final SearchBarController<Product> _searchBarController = SearchBarController();
  @override
  Widget build(BuildContext context) {
    Future<List<Product>> _getALlPosts(String text) async {
      await Future.delayed(Duration(seconds: text.length == 5 ? 2 : 1));
      List<Product> prods = await Provider.of<Products>(context,listen: false).getBuyName(text);
      return prods;
    }
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Product>(

          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _getALlPosts,
          //searchBarStyle: SearchBarStyle(backgroundColor: Theme.of(context).primaryColorLight),
          icon: Icon(Icons.search,color: Theme.of(context).backgroundColor,),
          searchBarController: _searchBarController,
          placeHolder: Center(child: Text("Place Holder")),
          cancellationWidget: Center(child: Text("Cancel")),
          emptyWidget: Center(child:Text("No Item Found")),
//          searchBarStyle: SearchBarStyle(
//            borderRadius: BorderRadius.circular(15),
//            backgroundColor: Theme.of(context).primaryColor,
//          ),

          onCancelled: () {
            print("Cancelled triggered");
          },
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          onItemFound: (Product post, int index) {
            return Card(
             // color: Theme.of(context).primaryColor,
              child: ListTile(
                leading: CircleAvatar(child: FittedBox(child: Image.network(post.imageUrl)),),
                trailing: Icon(Icons.shop,color: Theme.of(context).primaryColor,),
                title: Text(post.title),
                subtitle: Text("${post.price}"),
                onTap: (){
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: post.id,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

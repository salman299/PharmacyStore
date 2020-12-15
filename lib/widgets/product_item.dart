import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isExpended=false;
  int count=0;
  bool firstTime=true;


  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    //final cart = Provider.of<Cart>(context, listen: false);
    //print("Refresh this screen");
    // if (firstTime)
    //   {
    //     setState(() {
    //       count=cart.itemQuantity(product.id);
    //       print(count);
    //       if (count!=0)
    //         isExpended=true;
    //       firstTime=false;
    //     });
    //   }
    return
      GestureDetector(
        onTap: (){
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  );
        },
        child: Consumer<Cart>(
          builder: (ctx,cart, ch){
            isExpended=cart.items.containsKey(product.id);
            return Container(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: !isExpended ? Colors.black.withOpacity(0.50): Theme.of(context).primaryColor,
                          width: 0.3,
                        ),
                        // boxShadow: [BoxShadow(
                        //   color: Colors.black.withOpacity(0.16),
                        //   offset: Offset(0,3),
                        //   blurRadius: 6,
                        // )]
                      ),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.scaleDown,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.16),
                          blurRadius: 6,
                          offset: Offset(0,3),
                          spreadRadius:1,
                        )]
                      ),
                      child: isExpended ? Container(
                        width: 25,
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(child: Icon(Icons.add,color: Theme.of(context).primaryColor,), onTap: (){
                              cart.addItem(product.id, product.price, product.title,product.imageUrl);
                              // setState(() {
                              //   count+=1;
                              // });
                            },),
                            Container(
                              alignment: Alignment.center,
                              width: 25,
                              decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),
                              //padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Text(cart.items[product.id].quantity.toString(),style: TextStyle(color: Colors.white)),//Text(count.toString(),style: TextStyle(color: Colors.white),),
                            ),
                            GestureDetector(child: Icon(Icons.remove,color: Theme.of(context).primaryColor,), onTap: (){
                              cart.removeSingleItem(product.id);
                              // setState(() {
                              //   count-=1;
                              //   if (count==0)
                              //     isExpended=false;
                              // });
                            },),
                          ],
                        ),
                      ): GestureDetector(
                        onTap: (){
                          cart.addItem(product.id, product.price, product.title,product.imageUrl);
                          // setState(() {
                          //   count+=1;
                          //   isExpended=true;
                          // });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12,
                          child: Center(child: Icon(Icons.add,color: Theme.of(context).primaryColor,)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "RS " + product.price.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                        product.title,
                        style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.50)),
                        textAlign: TextAlign.left,
                      ),
                ),
              ),
            ],
          ),
    );
  }
        ),
      );




    //   ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     child: GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).pushNamed(
    //           ProductDetailScreen.routeName,
    //           arguments: product.id,
    //         );
    //       },
    //       child: Image.network(
    //         product.imageUrl,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     footer: GridTileBar(
    //       backgroundColor: Colors.black87,
    //       leading: Consumer<Product>(
    //         builder: (ctx, product, _) => IconButton(
    //               icon: Icon(
    //                 product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //               ),
    //               color: Theme.of(context).accentColor,
    //               onPressed: () {
    //                 product.toggleFavoriteStatus(authToken.token,authToken.userId);
    //               },
    //             ),
    //       ),
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         icon: Icon(
    //           Icons.shopping_cart,
    //         ),
    //         onPressed:
    //         ()
    //         {
    //           cart.addItem(product.id, product.price, product.title);
    //           Scaffold.of(context).hideCurrentSnackBar();
    //           Scaffold.of(context).showSnackBar(SnackBar(
    //             content: Text('Added item to Card!'),
    //             duration: Duration(seconds: 2),
    //             action: SnackBarAction(label: 'UNDO', onPressed: (){
    //                     cart.removeSingleItem(product.id);
    //             },),
    //           ));
    //         },
    //         color: Theme.of(context).accentColor,
    //       ),
    //     ),
    //   ),
    // );
  }
}


// Scaffold.of(context).hideCurrentSnackBar();
// Scaffold.of(context).showSnackBar(SnackBar(
//   content: Text('Added item to Card!'),
//   duration: Duration(seconds: 2),
//   action: SnackBarAction(label: 'UNDO', onPressed: (){
//     cart.removeSingleItem(product.id);
//   },),
// ));
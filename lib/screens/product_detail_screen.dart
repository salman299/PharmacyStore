import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/custom_icons_icons.dart';
import 'package:softwareengineering/providers/auth.dart';
import 'package:softwareengineering/providers/product.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool firstTime=true;
  Product loadedProduct;
  String token;
  String userId;
  bool isFavourite=false;
  @override
  void setState(fn) {
    // TODO: implement setState

    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    if (firstTime){
      final productId = ModalRoute.of(context).settings.arguments as String; // is the id!
      loadedProduct = Provider.of<Products>(
        context,
        listen: false,
      ).findById(productId);
      //final cart = Provider.of<Cart>(context, listen: false);
      token= Provider.of<Auth>(context,listen: false).token;
      userId= Provider.of<Auth>(context,listen: false).userId;
      setState(() {
        firstTime=false;
        isFavourite=loadedProduct.isFavorite;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title,style: TextStyle(fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor),),
        elevation: 1,
        backgroundColor: Color(0xFFf6f5f5),
        leading: IconButton(
          onPressed: ()=>Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios,color:  Color(0xFFFE7262),size: 18,),
        ),
        actions: [
          IconButton(
              icon: Icon(
                loadedProduct.isFavorite ? CustomIcons.heart__1_ : CustomIcons.heart,
              color: Colors.red,
              ),

              onPressed: () {
                setState(() {
                  loadedProduct.toggleFavoriteStatus(token,userId);
                  isFavourite=!isFavourite;
                });

              },
            ),
        ],
      ),
      // floatingActionButton:
      //     Builder(
      //       builder: (context)=> FloatingActionButton.extended(onPressed: () async {
      //         cart.addItem(loadedProduct.id, loadedProduct.price, loadedProduct.title);
      //         Scaffold.of(context).hideCurrentSnackBar();
      //         Scaffold.of(context).showSnackBar(SnackBar(
      //           content: Text('Added item to Card!'),
      //           duration: Duration(seconds: 4),
      //           action: SnackBarAction(label: 'UNDO', onPressed: (){
      //             cart.removeSingleItem(loadedProduct.id);
      //           },),
      //         ));
      //       },
      //         label: Text("Add Item"),
      //         icon: Icon(Icons.shopping_cart),),
      //     ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16),offset: Offset(0,3),blurRadius: 6)],
                borderRadius: BorderRadius.circular(20),

              ),
              height: 200,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                loadedProduct.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'RS ${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.start,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

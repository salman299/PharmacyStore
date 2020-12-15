import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/product_screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
   // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFFf6f5f5),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
            size: 18,
          ),
        ),
        title: Text("My Products",style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: () =>
            Navigator.of(context).pushNamed(EditProduct.routeName),
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (ctx,productData,child)=>Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (ctx, i) => UserProduct(
                              productData.items[i].id,
                              productData.items[i].title,
                              productData.items[i].imageUrl),
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}

import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String url;

  UserProduct(this.id,this.title, this.url);

  @override
  Widget build(BuildContext context) {
    final scaffold=Scaffold.of(context);
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(url),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor.withOpacity(0.40),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProduct.routeName, arguments: id);
                },
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
                onPressed: () async {
                  try{
                    final result=await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are You Sure!'),
                        content: Text('Do you want to delete product from your list'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes',style: TextStyle(color: Theme.of(context).primaryColor),),
                            onPressed: () {
                              Navigator.of(ctx).pop(true);
                            },
                          ),
                          FlatButton(
                            child: Text('No',style: TextStyle(color: Theme.of(context).primaryColor)),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                        ],
                      ),
                    );
                    if (result)
                      await Provider.of<Products>(context).deleteProduct(id);
                  } catch (error){
                    scaffold.showSnackBar(SnackBar(content: Text('Not deleted!'),));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

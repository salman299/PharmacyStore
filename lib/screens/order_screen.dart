import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart' show Order;
import '../widgets/oder_Item.dart';
import '../widgets/app_drawer.dart';
class OrderScreen extends StatelessWidget{
  static const routeName = '/order_screen';
  @override
  Widget build(BuildContext context) {
    //Order orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(future: Provider.of<Order>(context,listen: false).fetchAndSetOrders(),builder: (ctx,dataSnapShot){
        if (dataSnapShot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
        }
        else{
          if(dataSnapShot.error!=null)
            return Center(child: Text("Error Message"),);
          else
            return Consumer<Order>(builder: (ctx,orderData,child)=>
                ListView.builder(
                  itemCount:orderData.items.length,
                  itemBuilder: (ctx,i)=>OrderItem(orderData.items[i]),
                ),
            );
        }
      }
      ),
      );
  }
}

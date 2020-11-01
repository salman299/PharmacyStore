import 'package:flutter/material.dart';
import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 100,
//             padding: EdgeInsets.only(top: 30,),
//             alignment: Alignment.center,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 30,
//                   child: Text("S"),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text("Salman.khuwaja29@gmail.com",style: TextStyle(fontSize: 13),),
//                     Text("03063083866",style: TextStyle(fontSize: 10))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // AppBar(
//           //   title: Text('Hello Friends'),
//           // ),
//           ListTile(
//             leading: Icon(Icons.shop),
//             title: Text('Shop'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed('/');
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.payment),
//             title: Text('Order'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
//             },
//           ),
//           Divider(),
//           if (Provider.of<Auth>(context).userId ==
//               "bv8aEqFRI3SxoDRkueHZLm6GI0v1")
//             ListTile(
//               leading: Icon(Icons.payment),
//               title: Text('Product Managment'),
//               onTap: () {
//                 Navigator.of(context)
//                     .pushReplacementNamed(UserProductScreen.routeName);
//               },
//             ),
//           if (Provider.of<Auth>(context).userId == "bv8aEqFRI3SxoDRkueHZLm6GI0v1")
//             Divider(),
//           ListTile(
//             leading: Icon(Icons.exit_to_app),
//             title: Text('Logout!'),
//             onTap: () {
//               Navigator.of(context).pop();
//               Provider.of<Auth>(context, listen: false).signOut();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final _style=TextStyle(color: Theme.of(context).primaryColor,fontSize: dSize.height*0.020);
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: dSize.height*0.05,
              ),
              Container(
                height: dSize.height*0.10,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: ExactAssetImage('assets/image.png'),
                      radius: dSize.height * 0.05,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Samantha Smith',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: dSize.height * 0.023),
                        ),
                        SizedBox(
                          height: dSize.height*0.01,
                        ),
                        Text('0331-2345383',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: dSize.height * 0.018)),

                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: dSize.height * 0.02,
              ),
              Divider(
                height: 3,
                thickness: 3,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                height: dSize.height * 0.05,
              ),
              ListTile(
                onTap: (){
                  Navigator.of(context).pushReplacementNamed('/');
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).primaryColor,
                  size: dSize.height*0.030,
                ),
                title: Text(
                  'Home',
                  style: _style,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.fiber_smart_record,
                  color: Theme.of(context).primaryColor,
                  size: dSize.height*0.030,
                ),
                title: Text(
                  'Product Management',
                  style: _style,
                ),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
                },
              ),
              // ListTile(
              //   contentPadding: EdgeInsets.zero,
              //   leading: Icon(
              //     Icons.payment,
              //     color: Theme.of(context).primaryColor,
              //     size: dSize.height*0.030,
              //   ),
              //   title: Text(
              //     'Order',
              //     style: _style,
              //   ),
              //   onTap: (){
              //     Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
              //   },
              // ),
              // ListTile(
              //   onTap: (){
              //     //Navigator.of(context).pushReplacementNamed(SettingScreen.routeName);
              //   },
              //   contentPadding: EdgeInsets.zero,
              //   leading: Icon(
              //     Icons.settings,
              //     color: Theme.of(context).primaryColor,
              //     size: dSize.height*0.030,
              //   ),
              //   title: Text(
              //     'Setting',
              //     style: _style,
              //   ),
              // ),
              ListTile(
                onTap: (){
                  Navigator.of(context).pop();
                 Provider.of<Auth>(context, listen: false).signOut();
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).primaryColor,
                  size: dSize.height*0.030,
                ),
                title: Text(
                  'Logout',
                  style: _style,
                ),

              ),


            ],
          ),
        ),
      ),
    );
  }
}

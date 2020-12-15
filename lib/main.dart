import 'package:flutter/material.dart';
import 'package:softwareengineering/providers/global_variables.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import 'package:softwareengineering/screens/add_address_screen.dart';
import 'package:softwareengineering/screens/address_screen.dart';
import 'package:softwareengineering/screens/auth_screen.dart';
import 'package:softwareengineering/screens/checkout_screen.dart';
import 'package:softwareengineering/screens/main_navigation_screen.dart';
import 'package:softwareengineering/screens/search.dart';
import './screens/auth_screen1.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';

import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';

import './screens/cart_screen.dart';

import './screens/product_detail_screen.dart';
import './providers/cart.dart';
import './providers/order.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: GlobalVariables(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth,UserInfo>(
            update: (ctx,auth,previousUserInfo) =>UserInfo(auth.userId,previousUserInfo==null? []: previousUserInfo.address),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProduct) => Products(
                auth.token,
                auth.userId,
                previousProduct == null ? [] : previousProduct.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (ctx, auth, previousOrder) => Order(auth.token,
                auth.userId, previousOrder == null ? [] : previousOrder.items),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'MyShop',
                theme: ThemeData(
                  cursorColor: Color(0xFFE93354),
                  primaryColor: Color(0xFFFE7262),
                  iconTheme:  IconThemeData(color: Color(0xFFFE7262)),
                  backgroundColor: Colors.white,
                  accentColor: Color(0xFFFE7262),
                  fontFamily: 'Poppins',
                  inputDecorationTheme: InputDecorationTheme(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Color(0xFF191C3D).withOpacity(0.30),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFFE7262),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFFE7262),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  textTheme: TextTheme(
                    bodyText1: TextStyle(),
                    bodyText2: TextStyle(),
                  ).apply(
                    bodyColor: Color(0xFF191C3D),
                    displayColor: Color(0xFF191C3D),
                  ),
                ),
//                ThemeData(
//
//                  primarySwatch: Colors.purple,
//                  accentColor: Colors.deepOrange,
//                  fontFamily: 'Lato',
//
//                ),
                home: auth.isAuth ? MainNavigationScreen(): FutureBuilder(
                  future: auth.getCurrentUser(),
                  builder: (ctx, snap) => snap.connectionState ==
                          ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(),
                ),
                routes: {
                  //
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                  UserProductScreen.routeName: (ctx) => UserProductScreen(),
                  EditProduct.routeName: (ctx) => EditProduct(),
                  AddressScreen.routeName: (ctx)=> AddressScreen(),
                  Search.routeName: (ctx)=> Search(),
                  AddAddressScreen.routeName: (ctx)=>AddAddressScreen(),
                  CheckOutScreen.routeName : (ctx)=>CheckOutScreen(),
                });
          },
        ));
  }
}


//<img src="https://i.ibb.co/SwWN4YD/1-1520738033.jpg" alt="1-1520738033" border="0">
// <img src="https://i.ibb.co/3mFck3D/dokteronline-flagyl-1208-0-1452529201.jpg" alt="dokteronline-flagyl-1208-0-1452529201" border="0">
//<img src="https://i.ibb.co/48nFL1b/MGK5158-GSK-Panadol-Tablets-455x455.png" alt="MGK5158-GSK-Panadol-Tablets-455x455" border="0">
//<img src="https://i.ibb.co/2vk3BJS/sehat-com-pk-colospas-tab-135mg-30-s-50823-zoom.jpg" alt="sehat-com-pk-colospas-tab-135mg-30-s-50823-zoom" border="0">
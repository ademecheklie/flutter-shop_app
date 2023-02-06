import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_products.dart';
import 'package:flutter_complete_guide/screens/orderScreen.dart';
import 'package:flutter_complete_guide/screens/product_overview_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';

import '../screens/product_detail_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
//import './widgets/orderItem.dart' as o;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Products>(
              //create: (ctx) =>Products() ,
              update: (ctx, auth, previousProducts) => Products(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          // ignore: missing_required_param
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (ctx, auth, previousOrders) => Orders(
                  auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.orders)),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutologIn(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDeatilScreen.routeName: (ctx) => ProductDeatilScreen(),
              CartScreen.routrName: ((context) => CartScreen()),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductsScreen.routeName: (context) => EditProductsScreen()
            },
          ),
        ));
  }
}

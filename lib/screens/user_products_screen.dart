import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/app_drawer.dart';
import 'package:flutter_complete_guide/screens/edit_products.dart';
import 'package:flutter_complete_guide/widgets/user_products.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-products';
  const UserProductsScreen({Key key}) : super(key: key);
  
Future<Void> _onRefresh(BuildContext context)async{
 await Provider.of<Products>(context,listen: false).fetchAndSetResult(true);
}

  @override
  Widget build(BuildContext context) {
   // final prodData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _onRefresh(context),
        builder :(ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
         Center( child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: Consumer<Products>(
            builder :(context, prodData, _) => Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: prodData.items.length,
                itemBuilder: (_, i) =>
                    UserProducts(prodData.items[i].id,
                      prodData.items[i].title, prodData.items[i].imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

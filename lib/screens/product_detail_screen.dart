import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductDeatilScreen extends StatelessWidget {
  //const ProductDeatilScreen({Key key}) : super(key: key);
  // final String title;

  // ProductDeatilScreen(this.title);
  static const routeName = './product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.id,
                  child:
                      Image.network(loadedProduct.imageUrl, fit: BoxFit.cover)),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 15,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              loadedProduct.description,
              style: TextStyle(),
            ),
            SizedBox(
              height: 700,
            )
          ]))
        ],
      ),
    );
  }
}

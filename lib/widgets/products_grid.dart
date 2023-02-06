import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import '../providers/product.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class Products_Grid extends StatelessWidget {
  // const Products_Grid({
  //   Key key,
  //   @required this.loadedProducts,
  // }) : super(key: key);

  //final List<Product> loadedProducts;
  final bool showFavs;
  Products_Grid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavs ? productsData.favoriteItems() : productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) =>
        value: products[i],
        child: ProductItem(
            // products[i].id,
            //  products[i].title,
            //  products[i].imageUrl
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({Key key}) : super(key: key);
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDeatilScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child:Hero(
            tag: product.id,
            child: FadeInImage(placeholder: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEaXrkRqi4Q9Zz5tQzUQ0AFgCceD7Br4VGNQ&usqp=CAU'), image: NetworkImage(product.imageUrl,),fit: BoxFit.cover,))
          //  Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // )
          ,
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ct, product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toogleFavoriteStat(authData.token, authData.userId);
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(
                    'Item added successfully',
                    textAlign: TextAlign.center,
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
                // ((context) => Text(
                //       'Item added successfully',
                //       textAlign: TextAlign.center,
                //       style: TextStyle(backgroundColor: Colors.grey),
                //     )
                //     );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}

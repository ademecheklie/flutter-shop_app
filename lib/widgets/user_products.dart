import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/edit_products.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  const UserProducts(this.id, this.title, this.imageUrl);
  final String id;
  final String title;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductsScreen.routeName, arguments: id);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                        content: Text(
                      'item did not deleted',
                      textAlign: TextAlign.center,
                    )));
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ]),
        ),
      ),
    );
  }
}

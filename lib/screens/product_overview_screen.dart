import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/app_drawer.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';

enum FilteredOptions { All, Favorites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFav = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetResult()
          .then((_) => setState(() {
                _isLoading = false;
              }));
    }

    _isInit = false;

    super.didChangeDependencies();
  }
  //const ProductOverviewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilteredOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilteredOptions.Favorites) {
                    _showOnlyFav = true;
                  } else {
                    _showOnlyFav = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('favorites only'),
                      value: FilteredOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('all '),
                      value: FilteredOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routrName);
                },
              ),
              builder: ((_, cart, ch) => Badge(
                    value: cart.itemCount.toString(),
                    child: ch,
                  )))
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Products_Grid(_showOnlyFav),
    );
  }
}

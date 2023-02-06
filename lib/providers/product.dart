import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      this.isFavorite = false,
      @required this.imageUrl});

  void _setFavValues(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toogleFavoriteStat(String token, String userId) async {
    final oldStatus = isFavorite;

    //_setFavValues(oldStatus);
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-e79cc-default-rtdb.firebaseio.com/userFav/$userId/$id.json?auth=$token');
    try {
      final response =
          await http.put(url, body: json.encode( isFavorite));
      if (response.statusCode > 400) {
     _setFavValues(oldStatus);
    //    isFavorite = !isFavorite;
    // notifyListeners();
      }
    } catch (error) {
    //   isFavorite = !isFavorite;
    // notifyListeners();
      _setFavValues(oldStatus);
    }
  }
}

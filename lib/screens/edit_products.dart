// ignore_for_file: unnecessary_statements

import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/providers/product.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  EditProductsScreen({Key key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _editedproduct =
      Product(
        id: null,
       title: '', 
       description: '',
        price: 0,
         imageUrl: '');
  
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
   if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }
   @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedproduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedproduct.title,
          'description': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          // 'imageUrl': _editedproduct.imageUrl
          'imageUrl': ''
        };
        _imageUrlController.text = _editedproduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  
 Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedproduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedproduct.id, _editedproduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedproduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    // Navigator.of(context).pop();
  }

 

  @override
  Widget build(BuildContext context) {
    //final addSavedItem = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                        _editedproduct = Product(
                            title: value,
                            price: _editedproduct.price,
                            description: _editedproduct.description,
                            imageUrl: _editedproduct.imageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'please enter a value';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'please enter a number';
                          }
                          if (double.tryParse(v) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.parse(v) <= 0) {
                            return 'please enter a number greater than zero';
                          }
                          return null;
                        },
                       onSaved: (value) {
                        _editedproduct = Product(
                            title: _editedproduct.title,
                            price: double.parse(value),
                            description: _editedproduct.description,
                            imageUrl: _editedproduct.imageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                       onSaved: (value) {
                        _editedproduct = Product(
                            title: _editedproduct.title,
                            price: _editedproduct.price,
                            description: value,
                            imageUrl: _editedproduct.imageUrl,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                        validator: (v) {
                          if (v.isEmpty) {
                            return 'please enter a description';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter Url')
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                        _editedproduct = Product(
                            title: _editedproduct.title,
                            price: _editedproduct.price,
                            description: _editedproduct.description,
                            imageUrl: value,
                            id: _editedproduct.id,
                            isFavorite: _editedproduct.isFavorite);
                      },
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'please enter an imageUrl';
                                }
                                if (!v.startsWith('http') &&
                                    !v.startsWith('https')) {
                                  return 'please enter a valid imageUrl';
                                }
                                if (!v.endsWith('.jpg') &&
                                    !v.endsWith('.png')) {
                                  return 'please enter a valid image format';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}

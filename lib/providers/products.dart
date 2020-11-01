import 'dart:core';
import 'package:flutter/material.dart';
import '../module/http_exceptions.dart';
import './product.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Products with ChangeNotifier {
  String _authToken;
  String _userId;
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  // var _showFavoritesOnly = false;
  Products(this._authToken, this._userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts({String sortType="title", desc=false ,bool filterByUser = false}) async {
    //final diffProducts=filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"': '';
    print("Title $sortType");
    try{
      final exData=await Firestore.instance.collection("products").orderBy(sortType,descending: desc).getDocuments();
      if (exData==null)
        return;
      final exFavoriteData = await Firestore.instance.collection("userFravourite").document(_userId).get();

      final List<Product> loadedProducts = [];
      exData.documents.forEach((proData) {
        loadedProducts.add(Product(
          id: proData.documentID,
          price: proData['price'],
          description: proData['description'],
          imageUrl: proData['imageUrl'],
          title: proData['title'],
          isFavorite: exFavoriteData.data == null ? false : exFavoriteData.data[proData.documentID] ?? false,
        ));
      });
      _items = loadedProducts;
      for(int i=0;i<_items.length;i++)
        print(_items[i].title);
      notifyListeners();
    } catch(error){
      throw(error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product obj) async {
    await Firestore.instance.collection("products").add({
      'title': obj.title,
      'imageUrl': obj.imageUrl,
      'description': obj.description,
      'price': obj.price,
    }).then((response) {
      Product _newProduct = Product(
        id: response.documentID,
        title: obj.title,
        imageUrl: obj.imageUrl,
        description: obj.description,
        price: obj.price,
        isFavorite: obj.isFavorite,
      );
      _items.add(_newProduct);
      notifyListeners();
    }).catchError((error) {
      throw (error);
    });
  }

  Future<void> editProduct(String id, Product obj) async {
    final proIndex = items.indexWhere((prod) => prod.id == id);
    if (proIndex >= 0 && proIndex < _items.length) {
      await Firestore.instance
          .collection("products")
          .document(id)
          .updateData({
            'title': obj.title,
            'imageUrl': obj.imageUrl,
            'description': obj.description,
            'price': obj.price,
          })
          .then((_) => _items[proIndex] = obj)
          .catchError((error) {
            throw (error);
          });

    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((val) => val.id == id);
    await Firestore.instance
        .collection("products")
        .document(id)
        .delete()
        .then((value) => _items.removeAt(index))
        .catchError((error) => throw (error));
    notifyListeners();
  }
  Future<List<Product>> getBuyName(String search) async{
    final itemId = [];
    search=search.toLowerCase();
    for(int i=0;i<items.length;i++)
      {
        if (items[i].title.toLowerCase().contains(search))
          {
            itemId.add(items[i]);
          }
      }
    return [...itemId];
  }
  
}

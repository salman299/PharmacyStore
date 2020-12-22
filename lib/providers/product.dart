import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token,String userId) async{
    var localFav=isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      //Firestore.instance.collection("userFravourite").document(userId).setData(data)
      await Firestore.instance.collection("userFravourite").document(userId).updateData({"$id": isFavorite});
    }catch (error){
      isFavorite=localFav;
      notifyListeners();
      throw(error);
    }
    localFav=null;
  }
}

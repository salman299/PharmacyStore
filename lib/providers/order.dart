import 'dart:core';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime date;
  final String phoneNo;
  final String address;
  final List<CartItem> cardItem;

  OrderItem({this.id, this.amount,this.phoneNo, this.address ,this.cardItem, this.date});
}

class Order with ChangeNotifier {

  List<OrderItem> _items = [];
  String authToken;
  String userId;

  Order(this.authToken,this.userId,this._items);

  List<OrderItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    try{
      final userDataLocation=Firestore.instance.collection("order").document(userId).collection("user_orders");
      if (userDataLocation==null)
        return;
      final exData=await userDataLocation.getDocuments();
      final List<OrderItem> loadedOrder = [];
      exData.documents.forEach((proData) {
        loadedOrder.add(OrderItem(
            id: proData.documentID,
            date: DateTime.parse(proData['date']),
            amount: proData['amount'],
            phoneNo: proData['phoneNo'],
            address: proData['address'],
            cardItem: (proData['products'] as List<dynamic>)
                .map((item) => CartItem(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity: item['quentity'],
            ))
                .toList()));
      });
      _items=loadedOrder.reversed.toList();
      print(_items);
      notifyListeners();
    }catch (error){
      throw (error);
    }
  }

  Future<void> addItem(List<CartItem> card_items,String address, String phoneNo,double amount) async {

    final url = "https://software-engineering-4c565.firebaseio.com/order/$userId.json?auth=$authToken";
    final date = DateTime.now();
    try{
      final response=await Firestore.instance.collection("order").document(userId).collection("user_orders").add(
          {
            "amount": amount,
            "date": date.toIso8601String(),
            "address": address,
            "phoneNo": phoneNo,
            "products": card_items
                .map((item) => {
              "id": item.id,
              "title": item.title,
              "price": item.price,
              "quentity": item.quantity,
            })
                .toList()
          }
      );
      _items.insert(
          0,
          OrderItem(
            id: response.documentID,
            amount: amount,
            address: address,
            phoneNo: phoneNo,
            cardItem: card_items,
            date: date,
          ));
    }catch (error){
      throw (error);
    }
    notifyListeners();

  }
}

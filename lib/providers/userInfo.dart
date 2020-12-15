import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  final id;
  final location;
  final area;
  final city;
  Address({this.id,this.location, this.area, this.city});

}

class UserInfo with ChangeNotifier {
  String _uid;
  List<Address> _userAddress = [];
  int _selectedAddress=0;
  String _userPhone = "";

  UserInfo(this._uid,this._userAddress);

  List<Address> get address {
    return [..._userAddress];
  }

  int get selectedAddress{
    return _selectedAddress;
  }

  Address get myAddress{
    if (_selectedAddress<_userAddress.length)
      return _userAddress[_selectedAddress];
    return null;
  }
  String get uid {
    return _uid;
  }

  String get phoneNo {
    return _userPhone;
  }

  void setAddress(index) {
    _selectedAddress=index;
    notifyListeners();
  }

  Future<void> fetchAndSetAddress() async {
    try {
      if (_userAddress.length!=0)
        return;
      List<Address> addressLocal=[];
      final exData =
      await Firestore.instance.collection("user").document(_uid).collection("Address").getDocuments();
      exData.documents.forEach((proData) {
        addressLocal.add(Address(
          id: proData.documentID,
           location: proData["location"],
          area: proData["area"],
          city: proData["city"],
        ));
      });
      _userAddress=addressLocal;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  // Future<void> fetchAndSetAddress() async {
  //   try {
  //     if (_userAddress.length!=0)
  //       return;
  //     final exUserInformation =
  //         await Firestore.instance.collection("user").document(_uid).get();
  //     if (exUserInformation == null || exUserInformation.data == null) return;
  //     _userAddress = (exUserInformation.data['address'] as List<dynamic>)
  //         .map((item) => Address(
  //               location: item["location"],
  //               area: item["area"],
  //               city: item["city"],
  //             ))
  //         .toList();
  //     _userPhone = exUserInformation.data["phoneNo"];
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
  Future<void> addAddress( String city, String area,  String location) async {
    try {
      final response= await Firestore.instance.collection("user").document(_uid).collection("Address").add({
       "city": city,
       "area": area,
       "location": location,
      });
      _userAddress.add(Address(
        id: response.documentID,
        city: city,
        area: area,
        location: location,
      ));
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
  Future<void> setInfo(List<Address> address, String phone) async {
    try {
      Firestore.instance.collection("user").document(_uid).setData({
        "address": address,
        "phoneNo": address
            .map((item) => {
                  "location": item.location,
                  "area": item.area,
                  "city": item.city,
                })
            .toList()
      });
      _userAddress = address;
      _userPhone = phone;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}

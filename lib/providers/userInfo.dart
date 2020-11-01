import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo with ChangeNotifier{
  String _uid;
  String _userAddress="";
  String _userPhone="";
  UserInfo(this._uid);

  String get address{
    return _userAddress;
  }
  String get uid{
    return _uid;
  }
  String get phoneNo{
    return _userPhone;
  }
  Future<void> fetchAndSetAddress() async{
    try{
      print("Hello");
      print("USERID $_uid");
      final exUserInformation = await Firestore.instance.collection("user").document(_uid).get();
      if (exUserInformation==null || exUserInformation.data==null)
        return;
      _userAddress=exUserInformation.data["address"];
      _userPhone=exUserInformation.data["phoneNo"];
      notifyListeners();
    }catch (error){
      throw(error);
    }
    print(_userAddress);
    print(_userPhone);

  }
  Future<void> setInfo(String address,String phone) async{
    try{
      Firestore.instance
          .collection("user")
          .document(_uid)
          .setData(
          {
            "address": address,
            "phoneNo": phone,
          }
      ) ;
      _userAddress=address;
      _userPhone=phone;
    }catch(error){
      throw error;
    }
    notifyListeners();
  }
}
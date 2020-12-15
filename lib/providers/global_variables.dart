import 'package:flutter/cupertino.dart';

class GlobalVariables with ChangeNotifier {
  bool isCheckout=false;

  void changeCheckout(){
    isCheckout=!isCheckout;
    notifyListeners();
  }
}
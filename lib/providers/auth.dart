import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  String _token;
  String _udi;
  DateTime _expiryDate;
  String _userId;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  bool get isAuth {
    //print ("......Token.....  $token");
    return token != null;
  }

  String get userId {
    return _udi;
  }

  String get userActualId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null && _token != null &&
        DateTime.now().isBefore(_expiryDate))
      return _token;
    return null;
  }



  Future<bool> signIn(String email, String password) async {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (await isEmailVerified())
        {
          FirebaseUser user = result.user;
          final idToken = await user.getIdToken();

          _token = idToken.token;
          _expiryDate = idToken.expirationTime;
          _udi = user.uid;
          _userId= user.email;
          notifyListeners();
          return true;
        }
      return false;
  }

  Future<void> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    try {
      await sendEmailVerification();
      await _firebaseAuth.signOut();
    } catch (error) {
      print("Error Occured on sending email");
      throw (error);
    }
  }

  Future<bool> getCurrentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      if (user == null) {
        return false;
      }
      _udi = user.uid;
      _userId= user.email;
      final idToken = await user.getIdToken();
      _token = idToken.token;
      _expiryDate = idToken.expirationTime;
      notifyListeners();
      return true;
    } catch (error) {
      throw(error);
    }
  }

  Future<void> signOut() async {
      await _firebaseAuth.signOut();
      _udi=null;
      _token=null;
      _expiryDate=null;
      notifyListeners();
  }

  Future<void> passwordReset(String _email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
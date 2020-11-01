//import 'dart:math';
//import 'package:softwareengineering/providers/userInfo.dart';
//
//import '../module/http_exceptions.dart';
//import 'package:flutter/material.dart';
//import '../providers/auth.dart';
//import 'package:provider/provider.dart';
//enum AuthMode { Signup, Login }
//
//class AuthScreen extends StatelessWidget {
//  static const routeName = '/auth';
//
//  @override
//  Widget build(BuildContext context) {
//    final deviceSize = MediaQuery.of(context).size;
//    return Scaffold(
//      // resizeToAvoidBottomInset: false,
//      body: Stack(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: [
//                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
//                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
//                ],
//                begin: Alignment.topLeft,
//                end: Alignment.bottomRight,
//                stops: [0, 1],
//              ),
//            ),
//          ),
//          SingleChildScrollView(
//            child: Container(
//              height: deviceSize.height,
//              width: deviceSize.width,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Flexible(
//                    child: Container(
//                      margin: EdgeInsets.only(bottom: 20.0),
//                      padding:
//                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
//                      transform: Matrix4.rotationZ(-8 * pi / 180)
//                        ..translate(-10.0),
//                      // ..translate(-10.0),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(20),
//                        color: Colors.deepOrange.shade900,
//                        boxShadow: [
//                          BoxShadow(
//                            blurRadius: 8,
//                            color: Colors.black26,
//                            offset: Offset(0, 2),
//                          )
//                        ],
//                      ),
//                      child: Text(
//                        'Pharmacy',
//                        style: TextStyle(
//                          color: Theme.of(context).accentTextTheme.title.color,
//                          fontSize: 50,
//                          fontFamily: 'Anton',
//                          fontWeight: FontWeight.normal,
//                        ),
//                      ),
//                    ),
//                  ),
//                  Flexible(
//                    flex: deviceSize.width > 600 ? 2 : 1,
//                    child: AuthCard(),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class AuthCard extends StatefulWidget {
//  const AuthCard({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  _AuthCardState createState() => _AuthCardState();
//}
//
//class _AuthCardState extends State<AuthCard> {
//  final GlobalKey<FormState> _formKey = GlobalKey();
//  AuthMode _authMode = AuthMode.Login;
//  Map<String, String> _authData = {
//    'email': '',
//    'password': '',
//  };
//  var _isLoading = false;
//  final _passwordController = TextEditingController();
//  var _isResetPass=false;
//
//  void showErrorDialoge(String message,[String upperMessage="An error Message"] ){
//    showDialog(context: context,builder: (ctx) =>AlertDialog(title: Text(upperMessage),
//      content: Text(message),
//    actions: <Widget>[
//      FlatButton(
//        child: Text("okay"),
//        onPressed: ()=> Navigator.of(context).pop(),
//      )
//    ],)
//    );
//  }
//  Future<void> _submit() async{
//    if (!_formKey.currentState.validate()) {
//      // Invalid!
//      return;
//    }
//    _formKey.currentState.save();
//    setState(() {
//      _isLoading = true;
//    });
//
//    try{
//      if (_isResetPass==true){
//        await Provider.of<Auth>(context).passwordReset(_authData['email']);
//        showErrorDialoge("Reset Email Send Sucssesfuly ","Check your Email!");
//        setState(() {
//          _isResetPass=false;
//        });
//      }
//      else{
//        if (_authMode == AuthMode.Login) {
//          // Log user in
//          final isVarified=await Provider.of<Auth>(context,listen: false).signIn(_authData['email'], _authData['password']);
//          if (!isVarified)
//            showErrorDialoge("Please Varify your email first","Note!");
//          else
//            Provider.of<UserInfo>(context,listen: false).fetchAndSetAddress();
//        } else {
//          // Sign user up
//          await Provider.of<Auth>(context,listen: false).signUp(_authData['email'], _authData['password']);
//          showErrorDialoge("Verify your email and then Login","Verify your Email!");
//          _authMode=AuthMode.Login;
//        }
//      }
//
//    } catch(error){
//      String msg=error.message;
//      showErrorDialoge(msg);
//    }
//
//    setState(() {
//      _isLoading = false;
//    });
//  }
//
//  void _switchAuthMode() {
//    if (_isResetPass)
//      setState(() {
//        _isResetPass=false;
//        _authMode = AuthMode.Signup;
//        return;
//      });
//    if (_authMode == AuthMode.Login) {
//      setState(() {
//        _authMode = AuthMode.Signup;
//      });
//    } else {
//      setState(() {
//        _authMode = AuthMode.Login;
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final deviceSize = MediaQuery.of(context).size;
//    return Card(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(10.0),
//      ),
//      elevation: 8.0,
//      child: Container(
//        height: _authMode == AuthMode.Signup ? 320 : 260,
//        constraints:
//            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
//        width: deviceSize.width * 0.75,
//        padding: EdgeInsets.all(16.0),
//        child: Form(
//          key: _formKey,
//          child: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                TextFormField(
//                  decoration: InputDecoration(labelText: 'E-Mail'),
//                  keyboardType: TextInputType.emailAddress,
//                  validator: (value) {
//                    if (value.isEmpty || !value.contains('@')) {
//                      return 'Invalid email!';
//                    }
//                    return null;
//                  },
//                  onSaved: (value) {
//                    _authData['email'] = value;
//                  },
//                ),
//                if (!_isResetPass)
//                TextFormField(
//                  decoration: InputDecoration(labelText: 'Password'),
//                  obscureText: true,
//                  controller: _passwordController,
//                  validator: (value) {
//                    if (value.isEmpty || value.length < 5) {
//                      return 'Password is too short!';
//                    }
//                    return null;
//                  },
//                  onSaved: (value) {
//                    _authData['password'] = value;
//                  },
//                ),
//                if (!_isResetPass)
//                if (_authMode==AuthMode.Login)
//                  Align(
//                    alignment: Alignment.topRight,
//                    child: FlatButton(
//                      child: Text("Reset Password"),
//                      onPressed: (){
//                        setState(() {
//                          _isResetPass=true;
//                        });
//                      },
//                      //padding: EdgeInsets.symmetric(horizontal: 0.0),
//                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                      textColor: Theme.of(context).primaryColorLight,
//                    ),
//                  ),
//                if (_authMode == AuthMode.Signup)
//                  TextFormField(
//                    enabled: _authMode == AuthMode.Signup,
//                    decoration: InputDecoration(labelText: 'Confirm Password'),
//                    obscureText: true,
//                    validator: _authMode == AuthMode.Signup
//                        ? (value) {
//                            if (value != _passwordController.text) {
//                              return 'Passwords do not match!';
//                            // ignore: missing_return
//                            }
//                            return null;
//                          }
//                        : null,
//                  ),
//                SizedBox(
//                  height: _authMode==AuthMode.Login ? 0 : 20,
//                ),
//                if (_isLoading)
//                  CircularProgressIndicator()
//                else
//                  RaisedButton(
//                    child:
//                        Text(_authMode == AuthMode.Login ? _isResetPass ? 'RESET' : 'LOGIN' : 'SIGN UP'),
//                    onPressed: _submit,
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(30),
//                    ),
//                    padding:
//                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                    color: Theme.of(context).primaryColor,
//                    textColor: Theme.of(context).primaryTextTheme.button.color,
//                  ),
//                FlatButton(
//                  child: Text(
//                      '${_isResetPass ? "LOGIN": _authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
//                  onPressed: _switchAuthMode,
//                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                  textColor: Theme.of(context).primaryColor,
//                ),
//
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}

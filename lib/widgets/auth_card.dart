
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
class AuthCard extends StatefulWidget {
  final isLogin;
  AuthCard(this.isLogin);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>{

  bool _isResetPass=false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible=false;

  void showErrorDialoge(String message,[String upperMessage="An error Message"] ){
    showDialog(context: context,builder: (ctx) =>AlertDialog(title: Text(upperMessage),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          color: Theme.of(context).primaryColor.withOpacity(0.50),
          child: Text("okay"),
          onPressed: ()=> Navigator.of(context).pop(),
        )
      ],)
    );
  }

  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
      if (_isResetPass==true){
        await Provider.of<Auth>(context).passwordReset(_authData['email']);
        showErrorDialoge("Reset Email Send Sucssesfuly ","Check your Email!");
        setState(() {
          _isResetPass=false;
        });
      }
      else{
        if (widget.isLogin) {
          // Log user in
          final isVarified=await Provider.of<Auth>(context,listen: false).signIn(_authData['email'], _authData['password']);
          if (!isVarified)
            showErrorDialoge("Please Varify your email first","Note!");
//          else
//            Provider.of<UserInfo>(context,listen: false).fetchAndSetAddress();
        } else {
          // Sign user up
          await Provider.of<Auth>(context,listen: false).signUp(_authData['email'], _authData['password']);
          showErrorDialoge("Verify your email and then Login","Verify your Email!");
        }
      }

    } catch(error){
      String msg=error.message;
      showErrorDialoge(msg);
    }

    setState(() {
      _isLoading = false;
    });
  }

//  Future<void> _submit() async {
//    if (!_formKey.currentState.validate()){
//      return;
//    }
//    _formKey.currentState.save();
//    setState(() {
//      _isLoading = true;
//    });
//    try {
//      if (widget.isLogin)
//        await Provider.of<Auth>(context, listen: false)
//            .signIn(_authData['email'], _authData['password']);
//
//      await Provider.of<Auth>(context, listen: false)
//          .signUp(_authData['email'], _authData['password']);
////      showErrorDialog(
////        context: context,
////        message: "Check Your Provided Email",
////        upperMessage: "Verify your Email!",
////        fun: dialogExecute,
////      );
//    } catch (error) {
//      String msg = error.message;
//      print(msg);
//      //showErrorDialog(context: context, message: msg);
//    }
//    setState(() {
//      _isLoading = false;
//    });
//  }
  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final _hintStyle=TextStyle(
      color: Color(0xFF3951B6).withOpacity(0.50),
      fontSize: dSize.height * 0.020,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(41),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16),blurRadius: 6,offset: Offset(0,3))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("Welcome", style: TextStyle(fontWeight: FontWeight.w600,fontSize: dSize.height*0.03),),
                SizedBox(
                  width: dSize.width*0.60,
                    child: Text(widget.isLogin? "Sign in to order Medicines to your Door Steps": "Sign Up to be our Royal Customer", maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300,fontSize: dSize.height*0.02),)),
                SizedBox(
                  height: dSize.height * 0.04,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 12,
                          color: Color(0xFF1F54C3).withOpacity(0.15),
                        )
                      ]),
                  child: TextFormField(
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 0),
                      hintText: "Email",
                      hintStyle: _hintStyle,
                    ),
                    validator: (value) {
                      if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                ),
                SizedBox(
                  height: dSize.height * 0.04,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 12,
                          color: Color(0xFF1F54C3).withOpacity(0.15),
                        )
                      ]),
                  child: TextFormField(
                    obscureText: !_passwordVisible,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      hintText: "Password",
                      hintStyle: _hintStyle,
                      suffixIcon: FlatButton(
                        padding: EdgeInsets.zero,
                        focusColor: Colors.transparent,
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFCCCCCC),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                ),
                if(!widget.isLogin)
                SizedBox(
                  height: dSize.height * 0.04,
                ),
                if(!widget.isLogin)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 6),
                          blurRadius: 12,
                          color: Color(0xFF1F54C3).withOpacity(0.15),
                        )
                      ]),
                  child: TextFormField(
                    obscureText: !_passwordVisible,
                    //textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                      hintText: "Confirm Password",
                      hintStyle: _hintStyle,
                      suffixIcon: FlatButton(
                        padding: EdgeInsets.zero,
                        focusColor: Colors.transparent,
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFCCCCCC),
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                          // ignore: missing_return
                        }
                        return null;
                      }
                  ),

                ),
                SizedBox(
                  height: dSize.height * 0.04,
                ),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    //height: dSize.height * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFE7262),
                            Color(0xFFE93354),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )),
                    child: _isLoading
                        ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white)) : Text(
                      widget.isLogin? 'Login': 'SignUp',
                      style: TextStyle(color: Colors.white,fontSize: dSize.height*0.023 ,shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.16),
                            offset: Offset(0, 3),
                            blurRadius: 6)
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


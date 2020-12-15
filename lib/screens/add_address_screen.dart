import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import 'package:provider/provider.dart';
class AddAddressScreen extends StatefulWidget {
  static const routeName = '/add_address_screen';

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading=false;
  String city="";
  String area="";
  String address="";
  void _onSaved(){
    final _isValid= _formKey.currentState.validate();
    if(!_isValid)
      return;
    _formKey.currentState.save();
    setState(() {
      _isLoading=true;
    });
    Provider.of<UserInfo>(context).addAddress(city, area, address);
    setState(() {
      _isLoading=false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final _hintStyle = TextStyle(
      fontSize: dSize.height * 0.020,
      color: Color(0xFF191C3D),
    );
    return  Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFFf6f5f5),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
            size: 18,
          ),
        ),
      ),
      body: _isLoading? Center(child: CircularProgressIndicator()): Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Wrap(
              runSpacing: 20,
            children: [
              TextFormField(
                style: _hintStyle,
                //initialValue: hostel.name,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  labelText: "City",
                ),
                validator: (text) {
                  if (text.length < 3)
                    return "Name is very short";
                  else if (text == null) return "Field is required";
                  return null;
                },
                onSaved: (text) => city = text,
              ),
              TextFormField(
                style: _hintStyle,
                //initialValue: hostel.name,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  labelText: "Area",
                ),
                validator: (text) {
                  if (text.length < 3)
                    return "Name is very short";
                  else if (text == null) return "Field is required";
                  return null;
                },
                onSaved: (text) => area=text,
              ),
              TextFormField(
                style: _hintStyle,
                //initialValue: hostel.name,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  labelText: "Address",
                ),
                validator: (text) {
                  if (text.length < 3)
                    return "Name is very short";
                  else if (text == null) return "Field is required";
                  return null;
                },
                onSaved: (text) => address = text,
              ),
              GestureDetector(
                onTap: _onSaved,
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
                  child: Text('Save',
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
        ),
      ),
    );
  }
}

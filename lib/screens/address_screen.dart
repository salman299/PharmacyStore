import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:softwareengineering/providers/userInfo.dart';
import 'package:softwareengineering/screens/add_address_screen.dart';
import '../providers/userInfo.dart';
class AddressScreen extends StatefulWidget {
  static const routeName = '/address_screen';

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int itemSelected=0;
  bool groupValue=true;
  // List<Address> address = [
  //   Address(
  //     location: "A-57, Street 9, Mubarak Colony",
  //     area: "Pathan Colony",
  //     city: "Hyderabad",
  //   ),
  //   Address(
  //     location: "House No 11, F11/1",
  //     area: "Humza Road",
  //     city: "Islamabad",
  //   )
  //
  // ];

  @override
  Widget build(BuildContext context) {
    final address=Provider.of<UserInfo>(context,listen: false).address;
    final addressIndex=Provider.of<UserInfo>(context).selectedAddress;
    return Scaffold(
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
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddAddressScreen.routeName);
              },
              child: Text(
                "Add Address",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
        ],
      ),
      body: ListView.builder(
          itemCount: address.length,
          itemBuilder: (context, idx) => RadioListTile(
            value: addressIndex==idx? true: false,
            groupValue: groupValue,
            onChanged: (val){
              Provider.of<UserInfo>(context,listen: false).setAddress(idx);
            },
            title: Text(
              address[idx].location,
            ),
            subtitle: Text("${address[idx].area}, ${address[idx].city}"),
          ),
      ),
    );
  }
}

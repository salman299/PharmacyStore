import 'package:flutter/material.dart';
import 'package:softwareengineering/custom_icons_icons.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 44.0;
}

class ConfirmationCart extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  ConfirmationCart({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                GestureDetector(
                  onTap: Navigator.of(context).pop,
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
                    child: Text(
                     'Done',
                      style: TextStyle(color: Colors.white,shadows: [
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
          Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: Consts.avatarRadius,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: Consts.avatarRadius-5,
                child: FittedBox(
                  fit: BoxFit.fill,
                    child:Icon(Icons.check,size: 40,color: Colors.white,)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class CardInfo extends StatelessWidget {
  final String text;
  final IconData icon;

  CardInfo({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: text));
        Fluttertoast.showToast(
          msg: "Copied to Clipboard!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 15.0,
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            text,
            style: GoogleFonts.redHatDisplay(
                textStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )),
          ),
        ),
      ),
    );
  }
}

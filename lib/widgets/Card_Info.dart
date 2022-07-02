import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardInfo extends StatelessWidget {
  final String text;
  final IconData icon;

  CardInfo({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.teal,
          ),
          title: Text(
            text,
            style: GoogleFonts.redHatDisplay(
                textStyle: TextStyle(
              color: Colors.teal,
              fontSize: 18,
            )),
          ),
        ),
      ),
    );
  }
}

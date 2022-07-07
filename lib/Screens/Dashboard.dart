import 'package:assantendance/Screens/MarkAttendance.dart';
import 'package:assantendance/Screens/Profile.dart';
import 'package:assantendance/Screens/ViewAttendance.dart';
import 'package:assantendance/Screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../api/PDF_API.dart';
import '../api/pdf_invoice_api.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        elevation: 1.0,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text("Profile"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem(
                "View Attendance", "assets/attendance.png", 0, context),
            makeDashboardItem("Profile", "assets/personal.png", 1, context),
            makeDashboardItem("Report", "assets/attendance.png", 2, context),
            makeDashboardItem(
                "Personal Data", "assets/attendance.png", 3, context),
            makeDashboardItem(
                "Personal Data", "assets/personal.png", 4, context),
            makeDashboardItem(
                "Personal Data", "assets/personal.png", 5, context),
          ],
        ),
      ),
    );
  }
}

Card makeDashboardItem(
    String title, String image, int item, BuildContext context) {
  return Card(
      elevation: 2.5,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: InkWell(
          onTap: () {
            switch (item) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewAttendance()));
                break;

              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
                break;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                child: Image.asset(image, width: 69),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(title,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ));
}

void onSelected(BuildContext context, int item) async {
  switch (item) {
    case 0:
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
      break;

    case 1:
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Profile()));
      break;
  }
}

import 'package:assantendance/Screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            makeDashboardItem("Personal Data", "assets/personal.png"),
            makeDashboardItem("Attendance Data", "assets/attendance.png"),
            makeDashboardItem("Personal Data", "assets/attendance.png"),
            makeDashboardItem("Personal Data", "assets/attendance.png"),
            makeDashboardItem("Personal Data", "assets/personal.png"),
            makeDashboardItem("Personal Data", "assets/personal.png"),
          ],
        ),
      ),
    );
  }
}

Card makeDashboardItem(String title, String image) {
  return Card(
      elevation: 2.5,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: InkWell(
          onTap: () {},
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
  }
}

import 'package:assantendance/Screens/MarkAttendance.dart';
import 'package:assantendance/Screens/Profile.dart';
import 'package:assantendance/Screens/ViewAttendance.dart';
import 'package:assantendance/Screens/ViewAttendanceChart.dart';
import 'package:assantendance/Screens/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_mac/get_mac.dart';

import 'LeaveRequest.dart';

String macAddress = "";

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
                "Check Attendance", "assets/attendance.png", 0, context),
            makeDashboardItem("Profile", "assets/personal.png", 1, context),
            makeDashboardItem("Leave Request", "assets/leave.png", 2, context),
            makeDashboardItem("Log Out", "assets/logout.png", 3, context),
          ],
        ),
      ),
    );
  }
}

Card makeDashboardItem(
    String title, String image, int item, BuildContext context) {
  return Card(
      elevation: 2.7,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: InkWell(
          onTap: () async {
            switch (item) {
              case 0:
                initMacAddress();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAttendanceChart(macAddress)));
                break;

              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
                break;

              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaveRequest()));
                break;

              case 3:
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Welcome()),
                    (route) => false);
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

Future<void> initMacAddress() async {
  try {
    macAddress = await GetMac.macAddress;
    print(macAddress);
  } on PlatformException {
    print("Error Getting MAC Address");
  }
}

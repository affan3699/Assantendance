import 'package:assantendance/Screens/Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_widget/flutter_calendar_widget.dart';

import 'Welcome.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Panel"),
          backgroundColor: Colors.redAccent,
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
        drawer: NavigationDrawer(),
        body: FlutterCalendar(
          selectionMode: CalendarSelectionMode.single,
          scrollPhysics: BouncingScrollPhysics(),
          isHeaderDisplayed: true,
          style: CalendarStyle(
              markerColor: Colors.red,
              rangeLineColor: Colors.red,
              calenderPadding: EdgeInsets.all(5)),
          textStyle: const CalendarTextStyle(
            dayFontSize: 20,
            dayOfWeekFontSize: 20,
          ),
          onDayPressed: (DateTime date) {
            print(date);
          },
        ),
      ),
    );
  }
}

void onSelected(BuildContext context, int item) async {
  switch (item) {
    case 0:
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Welcome()), (route) => false);
      break;
  }
}

import 'package:assantendance/Screens/AdminDashboard.dart';
import 'package:assantendance/Screens/ManualRegistration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'AdminLeaveRequests.dart';
import 'Login.dart';
import 'ManualAttendance.dart';
import 'AdminStudents.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          Divider(color: Colors.black),
          _createDrawerItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()));
            },
            icon: Icons.summarize,
            text: 'Overview',
          ),
          Divider(color: Colors.black),
          _createDrawerItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminStudents()));
            },
            icon: Icons.person,
            text: 'Students',
          ),
          Divider(color: Colors.black),
          _createDrawerItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminLeaveRequests()));
            },
            icon: Icons.leave_bags_at_home,
            text: 'Leave Requests',
          ),
          Divider(color: Colors.black),
          _createDrawerItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManualAttendace()));
            },
            icon: Icons.note,
            text: 'Manual Attendance',
          ),
          Divider(color: Colors.black),
          _createDrawerItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManualRegistration()));
            },
            icon: Icons.app_registration,
            text: 'Manual Resgistration',
          ),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}

Widget _createHeader() {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.scaleDown,
        image: NetworkImage(
            "https://cdn-icons-png.flaticon.com/512/3208/3208977.png"),
      ),
    ),
    child: null,
  );
}

Widget _createDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}

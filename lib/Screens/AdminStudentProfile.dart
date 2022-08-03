import 'package:assantendance/Screens/AdminViewAttendanceChart.dart';
import 'package:assantendance/widgets/Card_Info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'AdminViewAttendance.dart';

class AdminStudentProfile extends StatefulWidget {
  String mac;

  AdminStudentProfile(this.mac);

  @override
  State<AdminStudentProfile> createState() => _AdminStudentProfile();
}

class _AdminStudentProfile extends State<AdminStudentProfile> {
  String email = "Loading...",
      phone = "Loading...",
      semester = "Loading...",
      name = "Loading...",
      macAddress = "",
      imageURL = "",
      brand = "Loading...";

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent.shade100,
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 180,
                  width: 180,
                  imageUrl: imageURL,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.downloading, size: 50.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  name,
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Pacifico",
                    ),
                  ),
                ),
                Text(
                  "DHA Suffa University",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Source Sans Pro"),
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                CardInfo(text: email, icon: Icons.email),
                CardInfo(text: "Semester $semester", icon: Icons.school),
                CardInfo(text: phone, icon: Icons.phone_android),
                CardInfo(text: brand, icon: Icons.info),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  margin: EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminViewAttendanceChart(widget.mac)));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      elevation: 5.0,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      minimumSize: Size.fromHeight(50.0),
                    ),
                    child: Text(
                      "View Attendance",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> getProfileData() async {
    macAddress = widget.mac;
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    final snapshot = await _databaseReference.get();
    //print(snapshot.value);
    print(macAddress);

    if (snapshot.exists) {
      final data = snapshot.value as dynamic;
      print("DATA = " + data.toString());

      setState(() {
        imageURL = data[macAddress]["URL"].toString();
        email = data[macAddress]["Email"].toString();
        name = data[macAddress]["Name"].toString();
        semester = data[macAddress]["Semester"].toString();
        phone = data[macAddress]["Phone"].toString();
        brand = data[macAddress]["Brand"].toString();
      });
    } else {
      print('No data available.');
    }
  }
}

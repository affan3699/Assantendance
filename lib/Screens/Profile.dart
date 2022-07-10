import 'package:assantendance/widgets/Card_Info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String email = "Loading...",
      phone = "Loading...",
      semester = "",
      name = "Loading...",
      macAddress = "",
      imageURL = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent.shade100,
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 100),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 75,
                backgroundImage:
                    imageURL != null ? NetworkImage(imageURL) : null,
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
              CardInfo(text: "Model Name", icon: Icons.info)
            ],
          ),
        ));
  }

  Future<void> initMacAddress() async {
    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      print("Error Getting MAC Address");
    }
  }

  Future<void> getProfileData() async {
    initMacAddress();
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    final snapshot = await _databaseReference.get();
    //print(snapshot.value);
    //print(macAddress);

    if (snapshot.exists) {
      final data = snapshot.value as dynamic;
      print("DATA = " + data.toString());

      setState(() {
        imageURL = data[macAddress]["URL"].toString();
        email = data[macAddress]["Email"].toString();
        name = data[macAddress]["Name"].toString();
        semester = data[macAddress]["Semester"].toString();
      });
    } else {
      print('No data available.');
    }
  }
}

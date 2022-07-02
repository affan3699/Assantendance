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
  String email = "",
      phone = "03312457852",
      semester = "",
      name = "",
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
                backgroundImage: NetworkImage(imageURL),
              ),
              SizedBox(height: 10.0),
              Text(name,
                  style: GoogleFonts.redHatDisplay(
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Pacifico",
                    ),
                  )),
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
              // we will be creating a new widget name info carrd
              CardInfo(text: email, icon: Icons.email),
              CardInfo(text: "Semester $semester", icon: Icons.school),
              CardInfo(text: phone, icon: Icons.phone),
              //CardInfo(text: location, icon: Icons.location_city),
              //TextButton(onPressed: _readdb_onechild, child: Text("HEllo"))
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
    final snapshot = await _databaseReference.child(macAddress).get();

    if (snapshot.exists) {
      final data = snapshot.value as dynamic;
      print(data);

      setState(() {
        imageURL = data[macAddress]["URL"];
        email = data[macAddress]["Email"];
        name = data[macAddress]["Name"];
        semester = data[macAddress]["Semester"];
      });
    } else {
      print('No data available.');
    }
  }
}

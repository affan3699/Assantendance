import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_mac/get_mac.dart';

class ViewAttendance extends StatefulWidget {
  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  String month = DateFormat('MMMM').format(DateTime.now()), macAddress1 = "";
  Color primary = Colors.blueAccent;
  late DatabaseReference ref;
  double screenWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 17.0),
                  child: Text(
                    month,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: pickMonth,
                    child: Text(
                      "Select Month",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: FirebaseAnimatedList(
                physics: BouncingScrollPhysics(),
                query: ref,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final data = snapshot.value as dynamic;
                  final data2 = snapshot.key as dynamic;
                  print(data);
                  print(macAddress1);
                  return Container(
                    margin: EdgeInsets.only(
                      top: index > 0 ? 12 : 0,
                      left: 0,
                      right: 0,
                    ),
                    height: 150,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                data2.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth / 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check In",
                                style: TextStyle(
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                data['CheckIn'],
                                style: TextStyle(
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Check Out",
                                style: TextStyle(
                                  fontSize: screenWidth / 20,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                data['CheckOut'],
                                style: TextStyle(
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void pickMonth() async {
    var month1 = await showMonthYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2099),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primary,
                secondary: primary,
                onSecondary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: primary,
                ),
              ),
            ),
            child: child!,
          );
        });
    if (month1 != null) {
      setState(() {
        month = DateFormat('MMMM').format(month1);
      });
    }
  }

  Future<void> initMacAddress() async {
    try {
      macAddress1 = await GetMac.macAddress;
      print(macAddress1);
    } on PlatformException {
      print("Error Getting MAC Address");
    }
  }

  Future<void> getData() async {
    try {
      macAddress1 = await GetMac.macAddress;
    } on PlatformException {
      print("Error Getting MAC Address");
    }
    print("MAC = " + macAddress1);
    ref = FirebaseDatabase.instance.ref("$macAddress1/Attendance");
  }
}

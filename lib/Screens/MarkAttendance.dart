import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_to_act/slide_to_act.dart';

class MarkAttendance extends StatefulWidget {
  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 31),
                  child: Text(
                    "Welcome, ",
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 19,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 31),
                  child: Text(
                    "Shayan",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width / 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Today Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width / 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 33.0),
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Check In",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "11:00",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "14:00",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "06 June 2022",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 35.0),
              child: Text(
                "19:00:01",
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black45,
                ),
              ),
            ),
            Builder(builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();

              return SlideAction(
                text: "Check In",
                outerColor: Colors.red,
                key: key,
                onSubmit: () {
                  key.currentState!.reset();
                },
              );
            })
          ],
        ),
      ),
    );
  }
}

import 'package:assantendance/Screens/Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_widget/flutter_calendar_widget.dart';
import 'package:pie_chart/pie_chart.dart';

import 'Welcome.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, double> dataMap = {'Female': 10.1, 'Male': 79.1};
  late DatabaseReference ref;
  String macAddress = "", name = "";
  double male = 0, female = 0;
  int notRegistered = 0;
  bool visible = false;
  List attendanceData = [];

  @override
  void initState() {
    super.initState();
    getAttendanceData().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Overview"),
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
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Total Students',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width / 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 9.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 900),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        colorList: [Colors.red, Colors.green.shade400],
                        centerText:
                            'Total\n' + attendanceData.length.toString(),
                        centerTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0),
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.rectangle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: true,
                          decimalPlaces: 1,
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 13),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.yellow.shade300,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.dangerous,
                                color: Colors.black,
                                size: 22,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Text(
                                  notRegistered == 1
                                      ? "$notRegistered Student is Not Registered"
                                      : "$notRegistered Students are Not Registered",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(14.0),
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(130),
                    border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Column(children: [
                            Text('Male',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold))
                          ]),
                          Column(
                            children: [
                              Text(
                                'Female',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      TableRow(children: [
                        Column(children: [
                          Text(male.toStringAsFixed(0),
                              style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(children: [
                          Text(female.toStringAsFixed(0),
                              style: TextStyle(fontSize: 20.0))
                        ]),
                      ]),
                    ],
                  ),
                ),
                //TextButton(onPressed: getAttendanceData, child: Text('Test')),
              ],
            ),
          )),
    );
  }

  Future<void> getAttendanceData() async {
    male = 0;
    female = 0;
    ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();
    attendanceData = snapshot.children.toList() as dynamic;
    print('Hello');
    print(attendanceData.length);

    for (int i = 0; i < attendanceData.length; i++) {
      if (attendanceData[i].child('Gender').value == 'Female') {
        female = female + 1.0;
      } else if (attendanceData[i].child('Gender').value == 'Male') {
        male = male + 1.0;
      } else {
        notRegistered++;
      }
    }

    // print('male = ' + male.toString());
    // print('female = ' + female.toString());

    dataMap['Male'] = male;
    dataMap['Female'] = female;

    if (notRegistered > 0) {
      setState(() {
        visible = true;
      });
    }
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

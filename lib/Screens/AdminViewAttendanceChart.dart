import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'AdminViewAttendance.dart';

class AdminViewAttendanceChart extends StatefulWidget {
  String mac;

  AdminViewAttendanceChart(this.mac);

  @override
  State<AdminViewAttendanceChart> createState() =>
      _AdminViewAttendanceChartState();
}

class _AdminViewAttendanceChartState extends State<AdminViewAttendanceChart> {
  Map<String, double> dataMap = {'Absent': 10.1, 'Present': 79.1};
  late DatabaseReference ref;
  String macAddress = "", name = "";
  double present = 0, absent = 0, percentage = 0, short = 0;
  bool visible = false;
  List attendanceData = [];

  @override
  void initState() {
    super.initState();
    getAttendanceData().whenComplete(() => setState(() {}));
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Chart'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    name,
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
                  height: 300,
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
                        centerText: 'Present\n' +
                            percentage.roundToDouble().toString() +
                            '%',
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
                                  "The Student is Short by $short%.",
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
                  margin: EdgeInsets.all(15.0),
                  child: Table(
                    defaultColumnWidth: FixedColumnWidth(109),
                    border: TableBorder.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                    children: [
                      TableRow(
                        children: [
                          Column(children: [
                            Text('Total',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))
                          ]),
                          Column(children: [
                            Text('Presents',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold))
                          ]),
                          Column(
                            children: [
                              Text(
                                'Absents',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                      TableRow(children: [
                        Column(children: [
                          Text(
                            attendanceData.length.toString(),
                            style: TextStyle(fontSize: 20.0),
                          )
                        ]),
                        Column(children: [
                          Text(present.toStringAsFixed(0),
                              style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(children: [
                          Text(absent.toStringAsFixed(0),
                              style: TextStyle(fontSize: 20.0))
                        ]),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  margin: EdgeInsets.only(top: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminViewAttendance(widget.mac)));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black54,
                      elevation: 5.0,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      minimumSize: Size.fromHeight(50.0),
                    ),
                    child: Text(
                      "Attendance Details",
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
        ),
      ),
    );
  }

  Future<void> getAttendanceData() async {
    macAddress = widget.mac;
    ref = FirebaseDatabase.instance.ref('$macAddress');
    final snapshot = await ref.get();
    final data = snapshot.value as dynamic;
    name = data['Name'];
    attendanceData = snapshot.child('Attendance').children.toList()
        as dynamic; // Attendance data

    for (int i = 0; i < attendanceData.length; i++) {
      if (attendanceData[i].child('CheckOut').value == 'Leave') {
        print(attendanceData[i].key);
        absent = absent + 1.0;
      } else {
        present = present + 1.0;
      }
    }

    print('Present = ' + present.toString());
    print('Absent = ' + absent.toString());

    dataMap['Present'] = present;
    dataMap['Absent'] = absent;

    percentage = (present / attendanceData.length) * 100;
    //percentage = 55.0;

    if (percentage < 75.0) {
      short = (75.0 - percentage).roundToDouble();
      setState(() {
        visible = true;
      });
    }
  }
}

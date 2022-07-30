import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../api/PDF_API.dart';
import '../api/pdf_invoice_api.dart';

class AdminViewAttendance extends StatefulWidget {
  String mac;

  AdminViewAttendance(this.mac);

  @override
  State<AdminViewAttendance> createState() => _AdminViewAttendance();
}

class _AdminViewAttendance extends State<AdminViewAttendance> {
  String month = DateFormat('MMMM').format(DateTime.now()), macAddress1 = "";
  late DatabaseReference ref;
  double screenWidth = 0;
  final GlobalKey<AnimatedListState> _key = GlobalKey();
  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  List<String> dates = <String>[];
  List<String> checkIn = <String>[];
  List<String> checkOut = <String>[];
  bool flag = true;
  Map<String, double> dataMap = {
    "Absent": 10,
    "Present": 80,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {});
    getData().whenComplete(() => setState(() {
          flag = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    dates.clear();
    checkIn.clear();
    checkOut.clear();

    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: flag == false
          ? SingleChildScrollView(
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
                    color: Colors.white,
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
                          centerText: '75.1%',
                          centerTextStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0),
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.left,
                            showLegends: true,
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
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 13),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.redAccent.shade100,
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
                                child: Text("The Student is Short by 10%.",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FirebaseAnimatedList(
                    key: _key,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    query: ref,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      final data = snapshot.value as dynamic; // Attendance data
                      final data2 = snapshot.key as dynamic; // Days

                      String getMonth = data2.toString().split(" ")[1];
                      if (getMonth == month) {
                        dates.add(data2);
                        checkIn.add(data['CheckIn']);
                        checkOut.add(data['CheckOut']);
                      }
                      //print(getMonth);
                      //print(data);
                      //print(macAddress1);
                      return getMonth == month
                          ? Container(
                              margin: EdgeInsets.only(
                                top: index > 0 ? 15 : 0,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                            )
                          : Container();
                    },
                  ),
                  SizedBox(height: 18.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: ElevatedButton(
                      onPressed: () {
                        generateReport();
                        print('Total = ' + dates.length.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        elevation: 5.0,
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        minimumSize: Size.fromHeight(50.0),
                      ),
                      child: Text(
                        "Generate Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void pickMonth() async {
    var month1 = await showMonthYearPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2023),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.redAccent,
                secondary: Colors.redAccent,
                onSecondary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.redAccent,
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

  Future<void> generateReport() async {
    // DataSnapshot snapshot = await ref.get();
    // final date = snapshot.value as dynamic;
    // print("PDF ka data = " + date.toString());

    //print(dates);

    final pdfFile =
        await PdfInvoiceApi.generate(month, dates, checkIn, checkOut);

    PdfApi.openFile(pdfFile);
  }

  Future<void> getData() async {
    macAddress1 = widget.mac;
    print("MAC = " + macAddress1);
    ref = FirebaseDatabase.instance.ref("$macAddress1/Attendance");
  }
}

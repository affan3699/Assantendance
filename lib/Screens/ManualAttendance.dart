import 'package:assantendance/Screens/Drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class ManualAttendace extends StatefulWidget {
  @override
  State<ManualAttendace> createState() => _ManualAttendaceState();
}

class _ManualAttendaceState extends State<ManualAttendace> {
  late DatabaseReference ref;
  String selectedValue = "Select Student", _selectedTime = '', mac = '';
  bool showSpinner = false;
  TextEditingController checkInTimeInput = TextEditingController();
  TextEditingController checkOutTimeInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  var items = [
    'Select Student',
  ];
  var students = Map();

  @override
  void initState() {
    getData().whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manual Attendance'),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          elevation: 2.0,
        ),
        drawer: NavigationDrawer(),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 205,
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/850/850960.png'),
                  ),
                ),
                child: null,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 49,
                margin: EdgeInsets.only(top: 21.0),
                padding: EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white,
                  border: Border.all(color: Colors.redAccent),
                ),
                child: TextField(
                  controller: dateInput,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd MMMM yyyy').format(pickedDate);
                      print(formattedDate);

                      setState(() {
                        dateInput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 49,
                  margin: EdgeInsets.only(top: 21.0),
                  padding:
                      EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 15.0),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          elevation: 2,
                          value: selectedValue,
                          items: items.map((String items) {
                            return DropdownMenuItem(
                                child: Text(items,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                value: items);
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              print(selectedValue);
                              var i = students.values
                                  .toList()
                                  .indexOf(selectedValue);
                              print(students.keys.toList()[i]);
                              mac = students.keys.toList()[i];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 49,
                margin: EdgeInsets.only(top: 21.0),
                padding: EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white,
                  border: Border.all(color: Colors.redAccent),
                ),
                child: TextField(
                  controller: checkInTimeInput,
                  onTap: () {
                    selectTime(context);
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Check In Time",
                      prefixIcon:
                          FaIcon(FontAwesomeIcons.clock, color: Colors.black),
                      border: InputBorder.none),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 49,
                margin: EdgeInsets.only(top: 21.0),
                padding: EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white,
                  border: Border.all(color: Colors.redAccent),
                ),
                child: TextField(
                  controller: checkOutTimeInput,
                  onTap: () {
                    selectTime2(context);
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: "Check Out Time",
                      prefixIcon:
                          FaIcon(FontAwesomeIcons.clock, color: Colors.black),
                      border: InputBorder.none),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 18.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: ElevatedButton(
                  onPressed: () {
                    if (checkInTimeInput.text.isNotEmpty ||
                        checkOutTimeInput.text.isNotEmpty) {
                      items.clear();
                      markAttendance();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please Select Times",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black87,
                        textColor: Colors.white,
                        fontSize: 15.0,
                      );
                    }
                    print(items);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    elevation: 5.0,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    minimumSize: Size.fromHeight(50.0),
                  ),
                  child: Text(
                    "Mark Attendance",
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
    );
  }

  Future<void> getData() async {
    ref = FirebaseDatabase.instance.ref();
    //final snapshot = await ref.get();
    //final data = snapshot.key as dynamic;

    await ref.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        // Map<dynamic, dynamic> values =
        //     child.child('LeaveRequests').value as dynamic;
        // values.forEach((key, values) {
        //   //items.add(key);
        // });
        //print(child.child('LeaveRequests').value);
        final name = child.value as dynamic;
        final mac = child.key as dynamic;
        items.add(name['Name'].toString());
        students[mac] = name['Name'];
        //print(name['Name']);
        //print(mac);
        print(students);
      }
    }, onError: (error) {});
    print("hello");
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        if (selectedTime.minute < 10) {
          checkInTimeInput.text =
              "${selectedTime.hour}:0${selectedTime.minute}";
          print("${selectedTime.hour}:0${selectedTime.minute}");
        } else {
          checkInTimeInput.text = "${selectedTime.hour}:${selectedTime.minute}";
          print("${selectedTime.hour}:${selectedTime.minute}");
        }
      });
    }
  }

  void selectTime2(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime2,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime2) {
      setState(() {
        selectedTime2 = timeOfDay;
        if (selectedTime2.minute < 10) {
          checkOutTimeInput.text =
              "${selectedTime2.hour}:0${selectedTime2.minute}";
          print("${selectedTime2.hour}:0${selectedTime2.minute}");
        } else {
          checkOutTimeInput.text =
              "${selectedTime2.hour}:${selectedTime2.minute}";
          print("${selectedTime2.hour}:${selectedTime2.minute}");
        }
      });
    }
  }

  Future<void> markAttendance() async {
    showSpinner = true;
    ref = FirebaseDatabase.instance.ref('$mac/Attendance');
    await ref.child(dateInput.text).set({
      "CheckIn": checkInTimeInput.text,
      "CheckOut": checkOutTimeInput.text,
    });

    showSpinner = false;

    Fluttertoast.showToast(
      msg: "Attendance Marked",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 15.0,
    );
    //print(data.toString());
  }
}

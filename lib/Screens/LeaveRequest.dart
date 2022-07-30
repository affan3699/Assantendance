import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_mac/get_mac.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class LeaveRequest extends StatefulWidget {
  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  List leaveRequests = [];
  String reason = "", message = "", macAddress1 = "";
  TextEditingController dateInput = TextEditingController();
  late DatabaseReference ref;
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    getLeaveRequests().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Requests'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)),
                    title: Text(
                      'Leave Request',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            reason = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Reason",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.question_mark),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: dateInput,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2030));

                            if (pickedDate != null) {
                              print(pickedDate);
                              String formattedDate =
                                  DateFormat('dd-MMMM-yyyy').format(pickedDate);
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
                            hintText: "Date",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        SizedBox(height: 11.0),
                        TextField(
                          onChanged: (value) {
                            message = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Message",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.message),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        child: Text(
                          'Send',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          elevation: 4.0,
                          minimumSize: Size.fromHeight(40.0),
                        ),
                        onPressed: () {
                          setState(() {
                            if (reason.isEmpty ||
                                message.isEmpty ||
                                dateInput.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Fields Cannot Be Empty!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                                fontSize: 15.0,
                              );
                            } else {
                              registerLeaveRequest();
                              Navigator.pop(context);
                              message = "";
                              reason = "";
                              dateInput.clear();
                            }
                          });
                        },
                      ),
                    ],
                    elevation: 5.0,
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: ref != null
          ? FirebaseAnimatedList(
              key: _key,
              physics: BouncingScrollPhysics(),
              query: ref,
              itemBuilder: (BuildContext context, snapshot,
                  Animation<double> animation, int i) {
                final data = snapshot.value as dynamic; // Leave data
                print(data);

                return SizeTransition(
                  key: UniqueKey(),
                  sizeFactor: animation,
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(
                        data['Reason'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: data['Approved'] == 0
                          ? Text('Pending')
                          : Text('Approved'),
                      trailing: data['Approved'] == 0
                          ? Icon(Icons.pending,
                              color: Colors.redAccent, size: 28.0)
                          : Icon(Icons.check_box,
                              color: Colors.green, size: 28.0),
                    ),
                  ),
                );
              })
          : CircularProgressIndicator(color: Colors.blue),
    );
  }

  Future<void> getLeaveRequests() async {
    try {
      macAddress1 = await GetMac.macAddress;
    } on PlatformException {
      print("Error Getting MAC Address");
    }
    print("MAC = " + macAddress1);
    ref = FirebaseDatabase.instance.ref("$macAddress1/LeaveRequests");
  }

  Future<void> registerLeaveRequest() async {
    String date = dateInput.text;
    ref.child(date).set({
      "Approved": 0,
      "Message": message,
      "Reason": reason,
    });
  }
}

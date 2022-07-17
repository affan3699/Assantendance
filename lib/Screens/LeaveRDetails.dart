import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LeaveRDetails extends StatefulWidget {
  List data;
  String mac;
  LeaveRDetails(this.data, this.mac);

  @override
  State<LeaveRDetails> createState() => _LeaveRDetailsState();
}

class _LeaveRDetailsState extends State<LeaveRDetails> {
  late DatabaseReference ref;
  String date = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Leave Details'),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, i) {
          int approve = widget.data[i].child('Approved').value;

          //print('Date = ' + date);

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.all(15.0),
            child: ListTile(
              title: Text(
                widget.data[i].child('Reason').value,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.data[i].child('Message').value),
              trailing: approve == 0
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          date = widget.data[i].key;
                          updateData();
                        });
                      },
                      child: Text('Approve'),
                    )
                  : Icon(Icons.check_box, color: Colors.green, size: 30.0),
            ),
          );
        },
      ),
    );
  }

  Future<void> updateData() async {
    String macAddress = widget.mac;
    ref = FirebaseDatabase.instance.ref('$macAddress/LeaveRequests/$date');
    await ref.update({
      "Approved": 1,
    });
    print("Updated");

    Fluttertoast.showToast(
      msg: "Request has been approved",
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

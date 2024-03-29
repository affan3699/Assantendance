import 'package:assantendance/Screens/LeaveRDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'Drawer.dart';
import 'Welcome.dart';

class AdminLeaveRequests extends StatefulWidget {
  @override
  State<AdminLeaveRequests> createState() => _AdminLeaveRequestsState();
}

class _AdminLeaveRequestsState extends State<AdminLeaveRequests> {
  late DatabaseReference ref;
  String macAddress1 = '';
  List leaveRequests = [];
  bool flag = true;

  @override
  void initState() {
    super.initState();
    print('google');
    //ref = FirebaseDatabase.instance.ref('B4:0F:B3:47:BF:8F');
    getAllLeaveRequests().whenComplete(() => setState(() {
          flag = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    leaveRequests.clear();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Leave Requests"),
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
        body: flag == false
            ? FirebaseAnimatedList(
                physics: BouncingScrollPhysics(),
                query: ref,
                itemBuilder: (BuildContext context, snapshot,
                    Animation<double> animation, int i) {
                  List data = snapshot.child('LeaveRequests').children.toList()
                      as dynamic; // Leave data
                  final name = snapshot.value as dynamic;
                  final mac = snapshot.key as dynamic;
                  print(name['Name']);
                  print(mac);
                  for (int i = 0; i < data.length; i++) {
                    print(data[i].child('Approved').value);
                    print(data[i].key);
                  }
                  //data.forEach((var num) => print(num));

                  // ref.onValue.listen((event) {
                  //   for (final child in event.snapshot.children) {
                  //     Map<dynamic, dynamic> values =
                  //         child.child('LeaveRequests').value as dynamic;
                  //     values.forEach((key, values) {
                  //       leaveRequests.add(key);
                  //     });
                  //     //print(child.child('LeaveRequests').value);
                  //     print(child.child('LeaveRequests').value);
                  //   }
                  // }, onError: (error) {});

                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(15.0),
                    child: ListTile(
                      title: Text(
                        name['Name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(mac),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LeaveRDetails(data, mac)));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.redAccent)),
                        child: Text('Open'),
                      ),
                    ),
                  );
                })
            : Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      ),
    );
  }

  Future<void> getAllLeaveRequests() async {
    ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();
    final data = snapshot.value as dynamic;
    print("hello houhh");
    //print(data.toString());
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

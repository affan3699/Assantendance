import 'package:assantendance/Screens/AdminStudentProfile.dart';
import 'package:assantendance/Screens/AdminViewAttendance.dart';
import 'package:assantendance/Screens/Drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AdminStudents extends StatefulWidget {
  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  late final DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    getAllStudents().whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Students'),
          centerTitle: true,
          elevation: 1.0,
          backgroundColor: Colors.redAccent,
        ),
        drawer: NavigationDrawer(),
        body: FirebaseAnimatedList(
            physics: BouncingScrollPhysics(),
            query: ref,
            itemBuilder: (BuildContext context, snapshot,
                Animation<double> animation, int i) {
              final name = snapshot.value as dynamic;
              final mac = snapshot.key as dynamic;
              print(name['Name']);
              print(mac);

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
                              builder: (context) => AdminStudentProfile(mac)));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.redAccent),
                        elevation:
                            MaterialStateProperty.resolveWith((states) => 2.0)),
                    child: Text('Open'),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> getAllStudents() async {
    ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();
    final data = snapshot.value as dynamic;
    print("hello houhh");
    //print(data.toString());
  }
}

import 'package:assantendance/Screens/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/Login.dart';
import 'Screens/Welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News App',
            theme: ThemeData(),
            initialRoute: FirebaseAuth.instance.currentUser == null
                ? "welcome_screen"
                : "dashboard_screen",
            routes: {
              "login_screen": (context) => Login(),
              "welcome_screen": (context) => Welcome(),
              "dashboard_screen": (context) => Dashboard(),
            },
          );
        }

        return Container();
      },
    );
  }
}

import 'package:assantendance/Screens/Login.dart';
import 'package:assantendance/Screens/SignUp.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Welcome(),
  ));
}

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 47),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Assantendance",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: 198,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/logo.png"))),
              ),
              Column(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size.fromHeight(58.0),
                      side: BorderSide(color: Colors.black),
                      shape: const BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  // creating the signup button
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      elevation: 5.0,
                      shape: const BeveledRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      minimumSize: Size.fromHeight(58.0),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

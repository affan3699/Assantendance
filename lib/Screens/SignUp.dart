import 'dart:io';

import 'package:assantendance/Screens/Dashboard.dart';
import 'package:assantendance/Screens/ForgotPassword.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_mac/get_mac.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "",
      password = "",
      selectedValue = "Semester",
      macAddress = "",
      name = "";
  bool showSpinner = false, isHiddenPassword = true;
  File? imageFile;
  late DatabaseReference _databaseReference;

  void _imgFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 40,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    initMacAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Set Up a Account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
                    ),
                    TextButton.icon(
                      onPressed: _imgFromCamera,
                      icon: Icon(
                        Icons.image,
                        size: 24.0,
                      ),
                      label: Text('Add Image'),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width,
                color: Colors.amber, // amber
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 49,
                      padding: EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                        bottom: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          name = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person_outline_sharp,
                            color: Colors.blueAccent,
                          ),
                          hintText: "Name",
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 49,
                      margin: EdgeInsets.only(top: 21.0),
                      padding: EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                        bottom: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: FaIcon(FontAwesomeIcons.envelope,
                              color: Colors.blueAccent),
                          hintText: "Email",
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 49,
                      margin: EdgeInsets.only(top: 21.0),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: isHiddenPassword,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: togglePassword,
                            child: Icon(isHiddenPassword == true
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key_outlined,
                            color: Colors.blueAccent,
                          ),
                          hintText: "Password",
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 49,
                      margin: EdgeInsets.only(top: 21.0),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.white,
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school_outlined, color: Colors.blueAccent),
                          SizedBox(width: 15.0),
                          DropdownButton(
                            value: selectedValue,
                            items: dropdownItems,
                            hint: Text("Select Semester"),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        sign_Up();
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already Have An Account?",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ForgotPassword()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sign_Up() async {
    if (email.isEmpty ||
        password.isEmpty ||
        selectedValue.isEmpty ||
        name.isEmpty ||
        imageFile == null) {
      Fluttertoast.showToast(
        msg: "Fields cannot be Empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } else {
      setState(() {
        showSpinner = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child("User_Image")
            .child(userCredential.user!.uid + ".jpg");

        await ref.putFile(imageFile!).whenComplete(() => null);

        final imageURL = await ref.getDownloadURL();

        _databaseReference.child(macAddress).set({
          "Name": name,
          "Email": email,
          "Semester": selectedValue,
          "URL": imageURL,
          "UID": userCredential.user!.uid,
        });

        Fluttertoast.showToast(
          msg: "You are Successfully Registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 15.0,
        );
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: "Email Already in-use try Again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 15.0,
          );
        } else if (e.code == 'invalid-email') {
          Fluttertoast.showToast(
            msg: "Incorrect Email Address!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 15.0,
          );
        } else if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: "Enter Strong Password!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 15.0,
          );
        }
      }
      setState(() {
        showSpinner = false;
      });
    }
  }

  void togglePassword() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("1"), value: "1"),
      DropdownMenuItem(child: Text("2"), value: "2"),
      DropdownMenuItem(child: Text("3"), value: "3"),
      DropdownMenuItem(child: Text("4"), value: "4"),
      DropdownMenuItem(child: Text("5"), value: "5"),
      DropdownMenuItem(child: Text("6"), value: "6"),
      DropdownMenuItem(child: Text("7"), value: "7"),
      DropdownMenuItem(child: Text("8"), value: "8"),
      DropdownMenuItem(child: Text("Semester"), value: "Semester"),
    ];
    return menuItems;
  }

  Future<void> initMacAddress() async {
    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      print("Error Getting MAC Address");
    }
  }
}

import 'dart:io';

import 'package:assantendance/Screens/Dashboard.dart';
import 'package:assantendance/Screens/ForgotPassword.dart';
import 'package:assantendance/Screens/Login.dart';
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
import 'package:device_info_plus/device_info_plus.dart';

import 'Drawer.dart';

class ManualRegistration extends StatefulWidget {
  @override
  _ManualRegistration createState() => _ManualRegistration();
}

class _ManualRegistration extends State<ManualRegistration> {
  String email = "",
      password = "",
      selectedValue = "Select",
      selectedValue2 = 'Select Gender',
      macAddress = "",
      phone = "",
      brand = "",
      name = "";
  bool showSpinner = false, isHiddenPassword = true;
  File? imageFile;
  late DatabaseReference _databaseReference;
  late final androidDeviceInfo;

  void _imgFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 12,
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
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      drawer: NavigationDrawer(),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.black54,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
                    ),
                    TextButton.icon(
                      onPressed: _imgFromCamera,
                      icon: Icon(
                        Icons.image,
                        size: 24.0,
                        color: Colors.redAccent,
                      ),
                      label: Text(
                        'Add Image',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.redAccent),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.0, // This One
                width: MediaQuery.of(context).size.width,
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
                        border: Border.all(color: Colors.redAccent),
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
                            color: Colors.redAccent,
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: FaIcon(FontAwesomeIcons.envelope,
                              color: Colors.redAccent),
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: isHiddenPassword,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: togglePassword,
                            child: Icon(
                              isHiddenPassword == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.redAccent,
                            ),
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key_outlined,
                            color: Colors.redAccent,
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
                        top: 4,
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
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: FaIcon(Icons.phone, color: Colors.redAccent),
                          hintText: "Phone No.",
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          macAddress = value;
                        },
                        maxLength: 17,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: FaIcon(Icons.wifi, color: Colors.redAccent),
                          hintText: "MAC Address",
                          counterText: "",
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          brand = value;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: FaIcon(Icons.android, color: Colors.redAccent),
                          hintText: "Brand of Device",
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.redAccent),
                          SizedBox(width: 15.0),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: selectedValue2,
                              items: dropdownItems2,
                              hint: Text("Select Gender"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue2 = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
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
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, color: Colors.redAccent),
                          SizedBox(width: 15.0),
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: selectedValue,
                              items: dropdownItems,
                              hint: Text("Select Semester"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                });
                              },
                            ),
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
                            color: Colors.redAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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
        selectedValue2.isEmpty ||
        name.isEmpty ||
        phone.isEmpty ||
        brand.isEmpty ||
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
    } else if (!email.contains('@')) {
      Fluttertoast.showToast(
        msg: "Invalid Email!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } else if (macAddress.length < 17) {
      Fluttertoast.showToast(
        msg: "Invalid MAC Address",
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

        _databaseReference.child(macAddress.toUpperCase()).set({
          "Name": name,
          "Email": email,
          "Phone": phone,
          "Semester": selectedValue,
          "Gender": selectedValue2,
          "Brand": brand,
          "URL": imageURL,
          "UID": userCredential.user!.uid,
        });

        _databaseReference.child("LeaveRequests").set({});

        Fluttertoast.showToast(
          msg: "User is Successfully Registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 15.0,
        );
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
      DropdownMenuItem(child: Text("Select"), value: "Select"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownItems2 {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
      DropdownMenuItem(child: Text("Select Gender"), value: "Select Gender"),
    ];
    return menuItems;
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);


  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _dobController;
  SetDataToTextField(data) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepOrange),
          backgroundColor: Colors.white,
          title: Text(
            "User Info",
            style: TextStyle(color: Colors.deepOrange),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 140, left: 80),
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                            child: Icon(Icons.camera_alt_outlined)),
                        SizedBox(width: 80.w),
                        ElevatedButton(
                            onPressed: () {},
                            style:
                                ElevatedButton.styleFrom(primary: Colors.grey),
                            child: Icon(Icons.image_outlined))
                      ],
                    ),
                  ),
                  height: 250,
                  width: double.infinity),
              TextFormField(
                controller: _nameController =
                    TextEditingController(text: data['name']),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange))),
              ),
              SizedBox(height: 15.h),
              TextFormField(
                controller: _phoneController =
                    TextEditingController(text: data['phone']),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange))),
              ),
              SizedBox(height: 15.h),
              TextFormField(
                controller: _dobController =
                    TextEditingController(text: data['dob']),
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange))),
              ),
              SizedBox(
                height: 50.h,
              ),
              ElevatedButton(
                  onPressed: () => updateData(),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange, minimumSize: Size(180, 50)),
                  child: Text(
                    "Update",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "dob": _dobController!.text
    }).then((value) => Fluttertoast.showToast(
        msg: "Updated Successful")); //print("Updated Successful"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SetDataToTextField(data);
          },
        ),
      )),
    );
  }
}

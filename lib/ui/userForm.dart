import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commers/UI/BottomnavScreen.dart';
import 'package:e_commers/UI/bottomNavPage/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  @override
  TextEditingController _nameControler = TextEditingController();
  TextEditingController _phoneControler = TextEditingController();
  TextEditingController _dobControler = TextEditingController();
  TextEditingController _genderControler = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext contxt) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobControler.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  Future sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameControler.text,
          "phone": _phoneControler.text,
          "dob": _dobControler.text,
          "gender": _genderControler.text,
        })
        .then((value) => print("user data added"))
        .catchError((error) => print("Something is wrong.$error"));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'User Form',
                    style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextField(
                  controller: _nameControler,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Name',
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.rtt_outlined),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextField(
                  controller: _phoneControler,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Phone Number',
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.pin),
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _dobControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Birth',
                    hintText: 'Select Your Date of Birth',
                    suffixIcon: IconButton(
                        onPressed: () => _selectDateFromPicker(context),
                        icon: Icon(Icons.calendar_today_outlined)),
                  ),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _genderControler,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Gender',
                      hintText: 'Choose Your Gender',
                      suffixIcon: DropdownButton<String>(
                        isExpanded: false,
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                            onTap: () {
                              setState(() {
                                _genderControler.text = value;
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (_) {},
                      )),
                ),
                SizedBox(height: 60.h),
                SizedBox(
                  width: 1.sw,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      sendUserDataToDB();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> bottom_navigatio_screen()));
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

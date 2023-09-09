import 'dart:async';
import 'dart:ui';
import 'package:e_commers/UI/signin_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class SplasScreen extends StatefulWidget {
  const SplasScreen({Key? key}) : super(key: key);

  @override
  _SplasScreenState createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  void initState() {
    Timer(Duration(seconds: 3),
    ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> Login_widget())));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "E-Commerce App",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 44.sp),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

import 'package:e_commers/UI/BottomnavScreen.dart';
import 'package:e_commers/UI/Registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login_widget extends StatefulWidget {
  const Login_widget({Key? key}) : super(key: key);

  @override
  _Login_widgetState createState() => _Login_widgetState();
}

class _Login_widgetState extends State<Login_widget> {
  TextEditingController _emialController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emialController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => bottom_navigatio_screen()));
      } else {
        Fluttertoast.showToast(msg: "Something is worng");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 60),
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 25),
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 30.sp, color: Colors.deepOrange),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "Glad to see you back buddy.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _emialController,
                          cursorColor: Colors.deepOrange,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepOrange)
                              ),
                              hintText: "Type Your E-Mail",
                              prefixIcon: Icon(
                                Icons.mail_outlined,
                                color: Colors.deepOrange,
                              )),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          cursorColor: Colors.deepOrange,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepOrange)
                              ),
                              hintText: "Enter Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.deepOrange,
                              ),
                              suffixIcon: _obscureText == true
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.visibility_off,
                                        color: Colors.deepOrange,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.deepOrange,
                                      ))),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 240),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forget Password?",
                              style: TextStyle(color: Colors.deepOrange),
                            )),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  signIn();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrange,
                                    fixedSize: Size.fromHeight(50)),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: 35.h),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            registration_page()));
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:e_commers/UI/signin_widget.dart';
import 'package:e_commers/UI/userForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';

class registration_page extends StatefulWidget {
  const registration_page({Key? key}) : super(key: key);

  @override
  _registration_pageState createState() => _registration_pageState();
}

class _registration_pageState extends State<registration_page> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emialController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emialController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => UserForm()));
      } else {
        Fluttertoast.showToast(msg: "Something is worng");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email");
      }
    } catch (e) {
      print(e);
    }
  }

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'password must have at least one special carrecter')
  ]);

  @override
  Widget build(BuildContext context) {
    String password;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 60),
              child: Text(
                "Sign Up",
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
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, left: 25),
                          child: Text(
                            "Welcome Buddy!",
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
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          child: TextFormField(
                            validator:
                                EmailValidator(errorText: 'enter a valid email'),
                            // validator: (value){
                            //   if (value!.isEmpty){
                            //     return "enter your email";
                            //   }
                            //   return null;
                            // },
                            controller: _emialController,
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.deepOrange)),
                                hintText: "Type Your E-Mail",
                                prefixIcon: Icon(
                                  Icons.mail_outlined,
                                  color: Colors.deepOrange,
                                )),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          child: TextFormField(
                            validator: passwordValidator,
                            onChanged: (val) => password = val,
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
                          height: 40.h,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      return signUp();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.deepOrange,
                                      fixedSize: Size.fromHeight(50.h)),
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        fontSize: 22.sp, color: Colors.white),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: 35.h),
                        Container(
                          margin: EdgeInsets.only(left: 20.h),
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
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Login_widget()));
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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

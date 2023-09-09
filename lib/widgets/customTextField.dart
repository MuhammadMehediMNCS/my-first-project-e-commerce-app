import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customeTextField(controllername, keyboardtype,hintText) {
  return TextField(
    controller: controllername,
    keyboardType: keyboardtype,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: hintText,
      prefixIcon: Icon(Icons.mail_outline)
    ),
  );
}
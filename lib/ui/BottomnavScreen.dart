import 'package:e_commers/UI/bottomNavPage/cart.dart';
import 'package:e_commers/UI/bottomNavPage/favourite.dart';
import 'package:e_commers/UI/bottomNavPage/home.dart';
import 'package:e_commers/UI/bottomNavPage/profile.dart';
import 'package:flutter/material.dart';

class bottom_navigatio_screen extends StatefulWidget {
  const bottom_navigatio_screen({ Key? key }) : super(key: key);

  @override
  _bottom_navigatio_screenState createState() => _bottom_navigatio_screenState();
}

class _bottom_navigatio_screenState extends State<bottom_navigatio_screen> {
  @override
  var pages = [
    Home(),
    favourite(),
    cart(),
    profile(),
  ];
  var _CurrentIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _CurrentIndex,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
        BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_sharp), label: 'Profile'),

      ],
      onTap: (index){
       setState(() {
         _CurrentIndex= index;
       });
      },
      ),
      body: pages[_CurrentIndex],
    );
  }
}
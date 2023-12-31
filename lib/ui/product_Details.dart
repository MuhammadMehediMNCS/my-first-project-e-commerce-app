import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  var _dotPosition = 0;

  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
    .doc(currentUser!.email)
    .collection("items")
    .doc()
    .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "image": widget._product["product-img"],
    }).then((value) => print("Add to Cart"));
  }
  
  Future addToFavoutire() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
    .doc(currentUser!.email)
    .collection("items")
    .doc()
    .set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "image": widget._product["product-img"],
    }).then((value) => print("Add to Favourite"));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(child: Text("Product Details",style: TextStyle(color: Colors.black),)),
        leading: GestureDetector(
          onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.deepOrange,
              size: 35,
            ),
            ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
            .collection("users-favourite-items")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("items")
            .where("name", isEqualTo: widget._product['product-name'])
            .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: IconButton(onPressed: () => snapshot.data.docs.length == 0
                ? addToFavoutire()
                : Fluttertoast.showToast(msg: "Already Added"),
                icon: snapshot.data.docs.length == 0
                ? Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                )
                :Icon(
                  Icons.done,
                  color: Colors.white,
                )
                ),
              ),
              );
            }
            )
        ],
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: CarouselSlider(
                items: widget._product["product-img"]
                    .map<Widget>((item) => Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.fitWidth))),
                        ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {
                        _dotPosition = val;
                      });
                    })),
          ),
          SizedBox(height: 10.h),
          Center(
            child: DotsIndicator(
              dotsCount: widget._product.length == 0 ? 1 : widget._product.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: Colors.deepOrange,
                spacing: EdgeInsets.all(2),
                activeSize: Size(8, 8),
                size: Size(6, 6),
                color: Colors.deepOrange.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(widget._product['product-price'].toString(),
          style: TextStyle(fontSize: 35.sp),),
              ),
          SizedBox(width: 120.w),
          ElevatedButton(onPressed: ()=>addToCart(),
          child: Text("Add to Cart"))
            ],
          ),
        SizedBox(height: 20.h),
          Text(widget._product['product-name'],
          style: TextStyle(fontSize: 25.sp),),
          SizedBox(height: 10.h),
          Text(widget._product['product-description'])
        ],
      )),
    );
  }
}

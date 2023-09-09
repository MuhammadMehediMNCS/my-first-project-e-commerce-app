import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commers/UI/product_Details.dart';
import 'package:e_commers/UI/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  TextEditingController _searchController = TextEditingController();

  List<String> _carouselImage = [];
  List _products = [];
  var _dotPosition = 0;
  var _firestoreInstance = FirebaseFirestore.instance;
  fatchCarouselImage() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carsoul-image").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImage.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });
    return qn.docs;
  }

  fatchproductImage() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });
    return qn.docs;
  }

  void initState() {
    fatchCarouselImage();
    fatchproductImage();
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("View Our Products"),
          leading: Icon(Icons.home),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
            },
            icon: Icon(Icons.search)),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
              //   child: Row(
              //     children: [
              //       Expanded(
              //           child: SizedBox(
              //         height: 60.h,
              //         child: TextField(
              //           controller: _searchController,
              //           decoration: InputDecoration(
              //             fillColor: Colors.white,
              //             focusedBorder: OutlineInputBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(0)),
              //                 borderSide: BorderSide(
              //                   color: Colors.blue,
              //                 )),
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(0)),
              //               borderSide: BorderSide(color: Colors.grey),
              //             ),
              //             hintText: "Search Product Here",
              //             hintStyle: TextStyle(fontSize: 20.sp),
              //           ),
              //           onTap: () => Navigator.push(context,
              //               MaterialPageRoute(builder: (_) => SearchScreen())),
              //         ),
              //       )),
              //       GestureDetector(
              //         child: Container(
              //           color: Colors.deepOrange,
              //           height: 60.h,
              //           width: 60.w,
              //           child: Center(
              //             child: Icon(
              //               Icons.search,
              //               color: Colors.white,
              //             ),
              //           ),
              //         ),
              //         onTap: () {},
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 10.h),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: _carouselImage
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(item),
                                          fit: BoxFit.fitWidth))),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
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
              DotsIndicator(
                dotsCount:
                    _carouselImage.length == 0 ? 1 : _carouselImage.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Colors.deepOrange,
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                  color: Colors.deepOrange.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 15.h),
              Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2,
                          childAspectRatio: 0.7),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetails(_products[index]))),
                          child: Card(
                            elevation: 5,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1.5,
                                      child: Image.network(
                                          _products[index]["product-img"][0]),
                                    ),
                                    Text(
                                      "${_products[index]["product-name"]}",
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                        "\৳${_products[index]["product-price"].toString()}"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

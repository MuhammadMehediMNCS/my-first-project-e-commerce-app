
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  double totalprice = 0;
  bool isload = true;
  List <Model> list = [];
  late AsyncSnapshot <QuerySnapshot> snapshot;
  @override
  void initState() {
    super.initState();
    getData();

  }
    Future<dynamic> getData() async {
    final document = (await FirebaseFirestore.instance
    .collection("users-cart-items")
    .doc(FirebaseAuth.instance.currentUser!.email)
    .collection("items")
    .get());
  

    for (int i = 0; i <document.docs.length; i++) {
      Model model = Model(
        document.docs[i].data()['name'],
        document.docs[i].data()['price'],
        document.docs[i].data()['image'][0],
        document.docs[i].id);
      list.add(model);
    }
    setState(() {
      isload = false;
    });
  }

double getTotalPrice() {
  totalprice = 0;
  list.forEach((element) {
    totalprice += element.price;
  });
  return totalprice;
}
@override

  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Cart Items"),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back))),
      body: SafeArea(
        child: isload? Center(
          child: CircularProgressIndicator(),
        ) :Column(
        children: [
          Expanded(
            child: ListView.builder(
                    itemCount:
                        snapshot.data == null ? 0 : snapshot.data!.docs.length,
                    itemBuilder: (_, index) {
                      DocumentSnapshot _documentSnapshot =
                          snapshot.data!.docs[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: Text(
                           " list[index].name",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          title: Text(
                            "\৳ ${list[index].price}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          trailing: GestureDetector(
                            child: CircleAvatar(
                              child: Icon(Icons.remove_circle),
                            ),
                            onTap: () {
                              FirebaseFirestore.instance
                                  .collection("users-cart-items")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("items")
                                  .doc(list[index].id)
                                  .delete();
                                list.remove(list[index]);
                                setState(() {
                                  
                                });
                            },
                          ),
                        ),
                      );
                    }),
          ),
          Text("Total Price -${getTotalPrice()}",
          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
        ]
      ),
        ),
      // StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection("users-cart-items")
      //         .doc(FirebaseAuth.instance.currentUser!.email)
      //         .collection("items")
      //         .snapshots(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //       if (snapshot.hasError) {
      //         return Center(
      //           child: Text("Something is Wrong"),
      //         );
      //       }
      //       return 
    );
  }
}

class Model {
  String name, image, id;
  int price;
  Model(this.name, this.price, this.image, this.id);
}
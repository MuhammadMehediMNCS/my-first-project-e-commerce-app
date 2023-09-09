import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commers/UI/bottomNavPage/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class favourite extends StatefulWidget {
  const favourite({Key? key}) : super(key: key);

  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title: Text("Favourite Items"),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back))),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something is Wrong"),
                );
              }
              return ListView.builder(
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
                          _documentSnapshot['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          "\৳ ${_documentSnapshot['price']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        trailing: GestureDetector(
                          child: CircleAvatar(
                            child: Icon(Icons.remove_circle),
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("users-favourite-items")
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .collection("items")
                                .doc(_documentSnapshot.id)
                                .delete();
                          },
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

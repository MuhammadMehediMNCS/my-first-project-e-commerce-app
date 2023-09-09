import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commers/Const/textfile.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  CollectionReference firestoreDocs =
      FirebaseFirestore.instance.collection('products');

  TextEditingController searchControler = TextEditingController();

//  get index => null;

//  get _products => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Search",
            style: TextStyle(fontSize: 20, color: Colors.deepOrange),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.deepOrange,
              )),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: searchControler,
                    decoration: textfilesStyle('search').copyWith(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.deepOrange,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                searchControler.clear();
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.deepOrange,
                            ))),
                  ),
                  getSearch()
                ],
              ),
            ),
          ),

          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Column(
          //   children: [
          //       TextFormField(
          //         cursorColor: Colors.deepOrange,
          //         decoration: InputDecoration(
          //           fillColor: Colors.white,
          //           focusedBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(30)),
          //             borderSide: BorderSide(color: Colors.deepOrange),
          //           ),
          //           enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(30)),
          //             borderSide: BorderSide(color: Colors.grey)
          //           ),
          //           hintText: "Search Products Here",
          //           hintStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
          //         ),
          //         onChanged: (val) {
          //           setState(() {
          //             inputText = val;
          //             print(inputText);
          //           });
          //         },
          //       ),
          //       Expanded(
          //           child: Container(
          //         child: StreamBuilder(
          //             stream: FirebaseFirestore.instance
          //                 .collection("products")
          //                 .where("product-name", isGreaterThanOrEqualTo: inputText)
          //                 .snapshots(),
          //             builder: (BuildContext context,
          //                 AsyncSnapshot<QuerySnapshot> snapshot) {
          //               if (snapshot.hasError) {
          //                 return Center(
          //                   child: Text("Something went wrong"),
          //                 );
          //               }

          //               if (snapshot.connectionState == ConnectionState.waiting) {
          //                 return Center(
          //                   child: Text("Lodding"),
          //                 );
          //               }

          //               return ListView(
          //                 children:
          //                     snapshot.data!.docs.map((DocumentSnapshot document) {
          //                   Map<String, dynamic> data =
          //                       document.data() as Map<String, dynamic>;
          //                   return Card(
          //                     elevation: 5,
          //                     child: ListTile(
          //                         title: Text(data['product-name']),
          //                         leading: Image.network(data['product-img'][0])),
          //                   );
          //                 }).toList(),
          //               );
          //             }),
          //       ))
          //   ],
          // ),
          //     )),
        ));
  }
}

Expanded getSearch() {
  var firestoreDocs;
  return Expanded(
      child: StreamBuilder(
          stream: firestoreDocs.snapshots().asBroadcastStream(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              );
            }
            var searchControler;
            if (searchControler.text.isEmpty) {
              return Text('No search result', style: TextStyle(fontSize: 16));
            } else {
              return ListView(
                children: [
                  snapshot.data!.docs
                      .where(
                    (QueryDocumentSnapshot<Object> element) =>
                        element["product-name"]
                            .toString()
                            .toLowerCase()
                            .contains(
                              searchControler.text.tpLowerCase(),
                            ),
                  )
                      .map((QueryDocumentSnapshot<Object> data) {
                    final name = data["product-name"];
                    final img = data["product-img"][0];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(
                            name,
                            style: TextStyle(fontSize: 20),
                          ),
                          leading: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Image.network(img),
                          ),
                        ),
                      ),
                    );
                  })
                ],
              );
            }
          }));
}

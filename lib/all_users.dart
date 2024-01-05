import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

             height: double.infinity,
             width: screenHeight*0.6,
              decoration:
              BoxDecoration(
               // color: Colors.white,
               // shape:

                // Set the shape to circular
                border: Border.all(
                  color: Colors.green,
                  width: 0.0,
                ),
              ),



              child:   Expanded(
                flex: 9,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .snapshots(includeMetadataChanges: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: CircularProgressIndicator());
                    }

                    var product = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        var productData = product[index].data()
                        as Map<String, dynamic>;

                        // Assuming "name" and "type" are fields in your product documents
                        String UserName =
                            productData['Name'] ?? 'No Name';
                        String UserContact =
                            productData['Contact'] ?? 'No Type';
                        String UserCity =
                            productData['City'] ?? 'No Type';

                        return ListTile(
                          title: Container(
                            width: screenWidth * 0.25,
                            height: 30,
                            // color: Colors.black,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Container(
                                  //color: Colors.yellow,
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                        screenWidth * 0.025,
                                        height:
                                        screenWidth * 0.025,
                                        decoration:
                                        BoxDecoration(
                                          color: Colors.white,
                                          shape:
                                          BoxShape.circle,
                                          // Set the shape to circular
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 0.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(2.0),
                                          child: Center(
                                            child: Image.asset(
                                                "assets/man.png"),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        ' $UserName',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color:
                                            Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            // Show AlertDialog when the user clicks "View"
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext
                                              context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'User Information', textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,

                                                    ),
                                                  ),
                                                  content:
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisSize:
                                                    MainAxisSize
                                                        .min,
                                                    children: [
                                                      Text(
                                                          'Name:  $UserName'),
                                                      SizedBox(height: 5,),
                                                      Text(
                                                          'City:  $UserCity'),
                                                      SizedBox(height: 5,),
                                                      Text(
                                                          'Contact:  $UserContact'),
                                                      SizedBox(height: 5,),
                                                    ],
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          'Back'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Text("View",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .blue))),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore
                                                .instance
                                                .collection(
                                                'Users')
                                                .doc(product[
                                            index]
                                                .id)
                                                .delete();
                                          },
                                          child: Text("Delete",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .red))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          // Add more details as needed
                        );
                      },
                    );
                  },
                ),
              ),




            ),
          ),
        ),
      )),
    );
  }
}

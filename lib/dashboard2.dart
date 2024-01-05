import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:lactgo_dashbard/all_sellers.dart';
import 'package:lactgo_dashbard/all_users.dart';
import 'package:lactgo_dashbard/login.dart';

class DDashboard extends StatefulWidget {
  const DDashboard({Key? key}) : super(key: key);

  @override
  State<DDashboard> createState() => _DDashboardState();
}

class _DDashboardState extends State<DDashboard> {

  late User? _user;

  Future<List<Map<String, dynamic>>> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('graph').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('admin').doc(userId).get();

    return snapshot.data() ?? {};
  }


  List<FlSpot> chartData = [];



  @override
  Widget build(BuildContext context) {


    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          toolbarHeight: screenHeight * 0.15,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_open, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            "Admin Dashboard",
            style: TextStyle(
              fontSize: screenWidth * 0.018,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        drawer: Drawer(
          child: FutureBuilder<Map<String, dynamic>>(
            future: fetchUserData(_user?.uid ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              var userData = snapshot.data ?? {};
              String userName = userData['Name'] ?? "UserName"; // Default to "UserName" if not found

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Logo"),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.dashboard),
                        SizedBox(width: 10),
                        Text('Dashboard'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the dashboard
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.shopping_bag_rounded),
                        SizedBox(width: 10),
                        Text('Products'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the dashboard
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DDashboard()),
                      );
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text('Sellers'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the dashboard
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Seller()),
                      );
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text('Users'),
                      ],
                    ),
                    onTap: () {
                      // Navigate to the dashboard
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Users()),
                      );
                    },
                  ),
                  ListTile(
                    title: GestureDetector(
                      onTap: () async {
                        // Perform the logout operation
                        await FirebaseAuth.instance.signOut();

                        // Navigate to the login screen or any other screen you want after logout
                        // Example using Navigator:
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 10),
                          Text('Logout', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    // height: screenHeight * 0.46,
                    // color: Colors.orange,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.26,
                          height: screenWidth * 0.20,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 2,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "User Profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
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
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Container(
                          width: screenWidth * 0.26,
                          height: screenWidth * 0.20,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "Seller",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                          Expanded(
                            flex: 9,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Seller')
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
                                                                'Seller Information', textAlign: TextAlign.start,
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
                                                            'Seller')
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
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Container(
                          width: screenWidth * 0.365,
                          height: screenWidth * 0.20,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "Products",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                          Expanded(
                            flex: 9,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('Products').snapshots(includeMetadataChanges: true),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }

                                var product = snapshot.data!.docs;

                                return GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: product.length,
                                  itemBuilder: (context, index) {
                                    var productData = product[index].data() as Map<String, dynamic>;
                                    var productId = product[index].id;

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                      //  width: screenWidth*0.12,
                                        //height: screenWidth*0.15,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.green),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Container(

                                                    //color: Colors.green,
                                                     // child: Image.asset(getImagePath(productData["ProductName"]),fit: BoxFit.cover ,)
                                                      child: Image.asset(getImagePath(productData["ProductName"]),fit: BoxFit.cover ,)
                                                  ),
                                                ),
                                              ),
                                            ),






                                            Padding(
                                              padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 4,bottom: 3),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    productData['ProductName'],
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width * 0.01,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  GestureDetector(onTap :() {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Delete Product"),
                                                        content: Text("Are you sure you want to delete this product?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              // Delete the product from Firebase
                                                              FirebaseFirestore.instance.collection('Products').doc(productId).delete();
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text("Delete"),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                  },child: Icon(Icons.delete,color: Colors.red,))

                                                ],
                                              ),
                                            ),
                                            Padding(

                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: Text(
                                                "Animal",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.01,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),

                                            Padding(

                                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "RS " ,
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width * 0.01,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    productData['Price']+"/:" ,
                                                    style: TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width * 0.01,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),



                                            // Add other product details if needed
                                          ],
                                        ),
                                      ),
                                    );
                                  },





                                );
                              },
                            ),
                          ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                     /*   Container(
                          width: screenWidth * 0.19,
                          height: screenWidth * 0.20,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "Manage Comments",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    // height: screenHeight * 0.46,
                    // color: Colors.orange,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth * 0.23,
                          height: screenWidth * 0.20,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "Manage Tips",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                flex: 6,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('Tips').snapshots(includeMetadataChanges: true),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    var product = snapshot.data!.docs;
                                    return ListView.builder(
                                      itemCount: product.length,
                                      itemBuilder: (context, index) {
                                        var productData = product[index].data() as Map<String, dynamic>;

                                        // Assuming "tip" is the field in your product documents
                                        String userTip = productData["tip"] ?? 'No Name';
                                        String tipNumber = (index + 1).toString(); // Adding 1 to make it 1-indexed
                                        // Extract the first three words
                                        List<String> words = userTip.split(' ');
                                        String truncatedTip = words.length > 2 ? words.sublist(0, 2).join(' ') + '...' : userTip;

                                        return ListTile(
                                          title: Container(
                                            width: screenWidth * 0.25,
                                            height: 30,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Text("Tip $tipNumber: ",style: TextStyle(fontSize: 14),),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        truncatedTip,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
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
                                                            builder: (BuildContext context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                  'Tips Information',
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                content: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text('Tip:  $userTip'),
                                                                    SizedBox(height: 5),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text('Back'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Text(
                                                          "View",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      GestureDetector(
                                                        onTap: () {
                                                          FirebaseFirestore.instance.collection('Seller').doc(product[index].id).delete();
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),


                              Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Container(
                                              height: 1,
                                             // width: screenWidth*0.21,
                                              color: Colors.grey,
                                            ),
                                          ),
                                         SizedBox(height: 10,),

                                         GestureDetector(
                                             onTap: () {

                                                 // Show AlertDialog for adding more tips
                                                 showDialog(
                                                   context: context,
                                                   builder: (BuildContext context) {
                                                     String newTip = '';

                                                     return AlertDialog(
                                                       title: Text('Add More Tips'),
                                                       content: Container(
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(10),
                                                           color: Colors.white,
                                                         ),
                                                         child: TextField(
                                                           decoration: InputDecoration(
                                                             labelText: 'Enter new tip',
                                                             border: OutlineInputBorder(
                                                               borderSide: BorderSide(color: Colors.green),
                                                               borderRadius: BorderRadius.circular(10),
                                                             ),
                                                           ),
                                                           onChanged: (value) {
                                                             newTip = value;
                                                           },
                                                         ),
                                                       ),
                                                       actions: [
                                                         TextButton(
                                                           onPressed: () {
                                                             if (newTip.isNotEmpty) {
                                                               // Add the new tip to the database or perform any other action
                                                               // For example, you can use FirebaseFirestore to add the tip to the 'Tips' collection
                                                                FirebaseFirestore.instance.collection('Tips').add({'tip': newTip});
                                                               Navigator.of(context).pop();
                                                             }
                                                           },
                                                           child: Text('Add Tip'),
                                                         ),
                                                         TextButton(
                                                           onPressed: () {
                                                             Navigator.of(context).pop();
                                                           },
                                                           child: Text('Cancel'),
                                                         ),
                                                       ],
                                                     );
                                                   },
                                                 );















                                             },
                                             child: Text("Add More Tips", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),

                                        ],
                                      ),
                                    )

                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Container(
                          width: screenWidth * 0.44,
                          height: screenWidth * 0.23,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "Generate Reports",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Sellers", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green

                                  ),),
                                  Text("Users", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue

                                  ),),
                                  Text("Orders", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red

                                  ),),


                                ],

                              ),
                            ),
                          ),
                          Expanded(
                            flex: 9, // 50% of the screen
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FutureBuilder(
                                future: fetchData(),
                                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<Map<String, dynamic>> data = snapshot.data!;

                                    return LineChart(
                                      LineChartData(
                                        // Customize your chart data here
                                        gridData: FlGridData(show: false),
                                        titlesData: FlTitlesData(show: true),
                                        borderData: FlBorderData(show: true),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: data
                                                .map((entry) =>
                                                FlSpot(entry['month'].toDouble(), entry['order'].toDouble()))
                                                .toList(),
                                            color: Colors.red,
                                          ),
                                          LineChartBarData(
                                            spots: data
                                                .map((entry) =>
                                                FlSpot(entry['month'].toDouble(), entry['seller'].toDouble()))
                                                .toList(),
                                            color: Colors.green,
                                          ),
                                          LineChartBarData(
                                            spots: data
                                                .map((entry) =>
                                                FlSpot(entry['month'].toDouble(), entry['user'].toDouble()))
                                                .toList(),
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        Container(
                          width: screenWidth * 0.21,
                          height: screenWidth * 0.25,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 8,
                                          right: 8),
                                      child: Text(
                                        "App Feedback",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 9,

                                 //   color: Colors.red,
                                    child:  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('FeedBack')
                                          .orderBy('Timestamp', descending: true) // Order by timestamp (latest first)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator(); // Show a loading indicator while fetching data.
                                        }

                                        List<Widget> feedbackWidgets = [];

                                        for (QueryDocumentSnapshot feedback in snapshot.data!.docs) {
                                          String userId = feedback['Userid'];
                                          String feedbackText = feedback['Feedback'];
                                          Timestamp timestamp = feedback['Timestamp'];

                                          feedbackWidgets.add(
                                            FutureBuilder(
                                              future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
                                              builder: (context, userDoc) {
                                                if (!userDoc.hasData) {
                                                  return CircularProgressIndicator(); // Show loading indicator for user data.
                                                }

                                                String userName = userDoc.data!['Name'];
                                                String formattedTime = DateFormat('h:mm a').format(timestamp.toDate());
                                                // Create a widget to display the feedback along with the user's name.
                                                return ListTile(
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width:
                                                                screenWidth * 0.028,
                                                                height:
                                                                screenWidth * 0.028,
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
                                                              SizedBox(width: 5,),
                                                              Text("$userName", style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black
                                                              ),),

                                                            ],
                                                          ),

                                                          Text("$formattedTime")



                                                        ],
                                                      ),
                                                      Text("$feedbackText"),
                                                    ],
                                                  ),

                                                );
                                              },
                                            ),
                                          );
                                        }

                                        return ListView(
                                          children: feedbackWidgets,
                                        );
                                      },
                                    ),
                                  ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

String getImagePath(String productName) {
  if (productName == null) {
    return "assets/default.png"; // Provide a default image path if productName is null
  } else if (productName == "Butter") {
    return "assets/butter.png";
  } else if (productName == "Cheese") {
    return "assets/cheese.png";
  } else if (productName == "Yogurt") {
    return "assets/yogurt.png";
  } else if (productName == "Milk") {
    return "assets/milk.png";
  } else {
    return "assets/milk.png"; // Provide a default image path for unknown products
  }
}

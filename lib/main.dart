import 'package:firebase_core/firebase_core.dart';




import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lactgo_dashbard/dashboard.dart';
import 'package:lactgo_dashbard/login.dart';

import 'dashboard2.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    print(firebaseUser);

    Widget firstWidget;

    if (firebaseUser != null) {
      firstWidget = DDashboard();

    } else {
      firstWidget = LoginPage();
     // firstWidget = LoginPage();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: firstWidget,
    );
  }


}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lactgo_dashbard/dashboard2.dart';

import 'dashboard.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return
      SafeArea(child: Scaffold(
        backgroundColor: Colors.black,

        body: Container(
          height: double.infinity,
          width: double.infinity,

          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Admin Login",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04,),



                  SizedBox( height: screenHeight*0.03,),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: screenWidth * 0.8 > 400 ? 400 : screenWidth * 0.8,

                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children :[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("Email", style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 1,),
                            TextField(

                              style: TextStyle(color: Colors.white),
                              controller: _emailController,
                              decoration: InputDecoration(

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ),

                            ),
                            SizedBox(height: 20,),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text("Password", style: TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: 1,),
                            TextField(

                              style: TextStyle(color: Colors.orange),
                              obscureText: !isPasswordVisible,
                              controller: _passwordController,
                              decoration: InputDecoration(

                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),


                              ),

                            ),
                            SizedBox( height: 30,),



                            Container(
                              width: screenWidth * 0.8 > 400 ? 400 : screenWidth * 0.8,
                              child: ElevatedButton(
                                onPressed: () {
                                  _loading ? null : _login();  // Handle button press
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: _loading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),]
                      ),
                    ),
                  )






                ],





              ),
            ),
          ),



        ),

      ));
  }

  Future<void> _login() async {
    if (_validateInputs()) {
      setState(() {
        _loading = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        String? currentUserId = _auth.currentUser?.uid;
// Check if the user ID exists in the "admin" collection
        DocumentSnapshot adminSnapshot = await FirebaseFirestore.instance
            .collection('admin')
            .doc(currentUserId)
            .get();

        if (adminSnapshot.exists) {
          // User is an admin, navigate to dashboard
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DDashboard()),
          );
        } else {
          // User is not an admin
          _showErrorSnackbar('You are not an admin.');

          // Log out the current logged-in user
          await _auth.signOut();
        }



      } catch (e) {
        _showErrorSnackbar(e.toString());
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  bool _validateInputs() {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      _showErrorSnackbar('Enter a valid email address.');
      return false;
    } else if (_passwordController.text.isEmpty) {
      _showErrorSnackbar('Enter a valid password.');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}

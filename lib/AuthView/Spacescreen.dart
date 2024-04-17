import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/Admin.dart';
import 'package:invest_iq/AuthView/Login.dart';

User? user = FirebaseAuth.instance.currentUser;

class Spacescreen extends StatefulWidget {
  const Spacescreen({Key? key});

  @override
  State<Spacescreen> createState() => _SpacescreenState();
}

class _SpacescreenState extends State<Spacescreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), checkingTheSavedData);
  }

  void checkingTheSavedData() async {
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      print("User found");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Admin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.redAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Logo_Tranferent1.png"),
                SizedBox(width: 20, height: 20,),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Welcome To Invest-IQ!",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.cyan, // Changed text color to white
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Let's Navigate the Markets Together for Profitable Trades!!",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.cyan, // Changed text color to white
                    ),
                  ),
                ),
                CircularProgressIndicator(),
                SizedBox(width: 50, height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

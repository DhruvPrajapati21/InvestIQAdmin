import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invest_iq/Admin.dart';
import 'package:invest_iq/AuthView/Signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invest_iq/AuthView/Forgetpassword.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Form_key = GlobalKey<FormState>();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController name2Controller = TextEditingController();
  var password = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Invest-IQ",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: Form_key,
          child: Column(
            children: [
              Image.asset("assets/images/Logo_Tranferent1.png"),
              Image.asset(
                "assets/images/g1.png",
                width: 110,
                height: 110,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!value.contains("@") ||
                        !value.contains(".com") ||
                        !value.contains("gmail")) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                  controller: name1Controller,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.cyan,
                      labelText: 'Enter Your Email',
                      labelStyle: TextStyle(color: Colors.cyan),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Password";
                    }
                    return null;
                  },
                  controller: name2Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Password',
                    labelStyle: TextStyle(color: Colors.cyan),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    prefixIconColor: Colors.cyan,
                    suffixIconColor: Colors.cyan,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          password = !password;
                        });
                      },
                      icon: password
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  obscureText: password,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (Form_key.currentState!.validate()) {
                        try {
                          final userSnapshot = await FirebaseFirestore.instance
                              .collection('Admin')
                              .where('Email', isEqualTo: name1Controller.text)
                              .limit(1)
                              .get();

                          if (userSnapshot.docs.isNotEmpty) {
                            final userData = userSnapshot.docs.first.data();
                            final savedPassword = userData['Password'];
                            if (savedPassword == name2Controller.text) {
                              // Password matches, proceed with login
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: name1Controller.text,
                                password: name2Controller.text,
                              );
                              Fluttertoast.showToast(
                                msg: "Successfully Logged In!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 11.0,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Admin()),
                              );
                            } else {
                              // Password doesn't match
                              print('Incorrect Password');
                              Fluttertoast.showToast(
                                msg: 'Incorrect password',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 11.0,
                              );
                            }
                          } else {
                            // User not found
                            print('User not found');
                            Fluttertoast.showToast(
                              msg: 'User not found',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 11.0,
                            );
                          }
                        } catch (e) {
                          print('Error: $e');
                          // Handle any potential errors here
                          Fluttertoast.showToast(
                            msg: 'An error occurred',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 11.0,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgetpassword()),
                      );
                    },
                    child: Text("Forget Password?",style: TextStyle(color: Colors.cyan, ),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text("Need an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text("Join us >>",style: TextStyle(color: Colors.cyan),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

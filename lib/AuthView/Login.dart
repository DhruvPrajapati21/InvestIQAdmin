import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invest_iq/Admin.dart';
import 'package:invest_iq/AuthView/Signup.dart';

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
        title: Center(
          child: Text(
            "Invest-IQ",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: Form_key,
          child: Column(
            children: [
              Image.asset("assets/images/Logo.png"),
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
                      return "Please enter email";
                    } else if (!value.contains("@") || !value.contains(".")) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (Form_key.currentState != null &&
                            Form_key.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: name1Controller.text,
                              password: name2Controller.text,
                            );
                            Fluttertoast.showToast(
                                msg: "Successfully Logged In",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Admin()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "user-not-found" ||
                                e.code == "wrong-password") {
                              String errorMessage = "Incorrect email or password. Please try again.";
                              if (e.code == "user-not-found") {
                                errorMessage = "Email not found. Please check your email address.";
                              } else if (e.code == "wrong-password") {
                                errorMessage = "Incorrect password. Please try again.";
                              }
                              Fluttertoast.showToast(
                                  msg: errorMessage,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
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
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text("Need an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup()));
                      },
                      child: Text("Join us >>")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

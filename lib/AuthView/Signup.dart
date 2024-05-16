import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setPersistence(Persistence.NONE);

  // Check if the user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  Widget homeScreen = user != null ? Admin() : Login();

  runApp(MyApp(homeScreen: homeScreen));
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Form_key = GlobalKey<FormState>();
  var password = false, con_password = true;
  bool passwordVisible = false;
  bool isNavigatingToLogin = false;
  bool con_passwordVisible = true;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  bool isLoading = false;
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();

  // Future<bool>doesRegisterExist(String email) async{
  //
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection("User")
  //       .where("email", isEqualTo: email)
  //       .get();
  //
  //   return querySnapshot.docs.isNotEmpty;
  // }
  //
  // Future<void>addRegisterToFirestore() async{
  //   final Name = name.text.trim();
  //   final Email = email.text.trim();
  //   final Password = pass.text.trim();
  //   final ConfirmPassword = cpass.text.trim();
  //
  //
  //   if(Name.isEmpty)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar
  //         (const SnackBar(content: Text("Please enter your name")));
  //     }
  //
  //   if(Email.isEmpty)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar
  //         (const SnackBar(content: Text("Please enter your email")));
  //     }
  //
  //   if(Password.isEmpty)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar
  //         (const SnackBar(content: Text("Please Enter your password")));
  //     }
  //
  //   if(ConfirmPassword.isEmpty)
  //     {
  //       ScaffoldMessenger.of(context).showSnackBar
  //         (const SnackBar(content: Text("Please re-enter your password")));
  //     }
  //
  //
  //   final doesExist = await doesRegisterExist(email.text);
  //
  //   if (doesExist) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Email already exists")),
  //     );
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //
  //     try
  //         {
  //           FirebaseFirestore.instance.collection("SignUp").add({
  //             'name': name.text,
  //             'email': email.text,
  //             'password': pass.text,
  //             'confirm password': cpass.text,
  //           }).then((value){
  //             name.clear();
  //             pass.clear();
  //             email.clear();
  //             cpass.clear();
  //             isLoading = false;
  //
  //             ScaffoldMessenger.of(context).showSnackBar
  //               (const SnackBar(content: Text("SugnUp Successfully")));
  //           });
  //         }
  //         catch (error)
  //   {
  //     print("Error Uploading Data: $error",);
  //   }
  //     {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   }  }
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
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    "assets/images/l1.png",
                    width: 130,
                    height: 130,
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter Your Full Name',
                        labelStyle: TextStyle(color: Colors.cyan),
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Colors.cyan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: email,
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
                    decoration: InputDecoration(
                        labelText: 'Enter Your Email Address',
                        labelStyle: TextStyle(color: Colors.cyan),
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Colors.cyan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pass,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a password";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      } else if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+={};:<>|./?,-]).{8,}$').hasMatch(value)) {
                        return "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character";
                      }
                      return null;
                    },
                    obscureText: !passwordVisible,
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
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cpass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Password";
                      }
                      return null;
                    },
                    obscureText: !con_passwordVisible,
                    decoration: InputDecoration(
                      hintText: "Please confirm your password",
                      label: const Text("Confirm Password"),
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
                            if (con_password == true) {
                              con_password = false;
                            } else {
                              con_password = true;
                            }


                            con_passwordVisible = !con_passwordVisible;
                          });
                        },
                        icon: Icon(
                          con_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please wait..."),
                            duration: Duration(seconds: 2), // Adjust the duration as needed
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds
                        setState(() {
                          isNavigatingToLogin = true;
                        });
                        if (Form_key.currentState!.validate()) {
                          if (pass.text == cpass.text) {
                            // Check if passwords match
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email.text, password: pass.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .add({
                                  "Username": name.text.trim(),
                                  "Email": email.text.trim(),
                                  "Password": pass.text.trim(),
                                });
                              });
                              name.clear();
                              email.clear();
                              pass.clear();
                              cpass.clear();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "SignUp Successfully",
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Password is too weak",
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                  ),
                                );
                              } else if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Email is already Registered",
                                      style: TextStyle(color: Colors.cyan),
                                    ),
                                  ),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Passwords do not match",
                                  style: TextStyle(color: Colors.cyan),
                                ),
                              ),
                            );
                          }
                        }

                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text("Join us Now >>",style: TextStyle(color: Colors.cyan),))
                  ],
                )
              ],
            )),
      ),
    );
  }
}

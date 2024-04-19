import 'package:flutter/material.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});
  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  bool passwordVisible = false;
  bool con_passwordVisible = true;
  var password = false,
      con_password = true;
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  void resetPassword() async {
    String email = _emailController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      // Show error message if passwords don't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match!"),
        ),
      );
      return;
    }
    try {
      // Check if email exists in Firestore
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('Admin')
          .where('Email', isEqualTo: email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        // Email exists, reset password using Firebase Authentication
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // Update password in Firestore user document
        await FirebaseFirestore.instance
            .collection('Admin')
            .doc(documents.first.id)
            .update({'Password': newPassword});

        // Show success message

        // Update password in Firebase Authentication
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

        // Show success message for password update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password updated successfully!"),
          ),
        );
      } else {
        // Email does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email not found. Please try again!"),
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred. Please try again later."),
        ),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Forget Password",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/forgot-password.png",
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _emailController,
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
                        labelText: "Enter Your Email",
                        labelStyle:
                        TextStyle(color: Colors.cyan),
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Colors.cyan,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _newPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Password";
                        }
                        return null;
                      },
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Enter Your New Password",
                        labelStyle:
                        TextStyle(color: Colors.cyan),
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
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter confirm Password";
                        }
                        return null;
                      },
                      obscureText: !con_passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Enter Your Confirm Password",
                        labelStyle:
                        TextStyle(color: Colors.cyan),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            resetPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Text("Forget Password"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

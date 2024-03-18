import 'package:flutter/material.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}
class _SignupState extends State<Signup> {
  final Form_key = GlobalKey<FormState>();
  var password = false, con_password = true;
  bool passwordVisible = false;
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
        title: Text("Invest-IQ",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Form(
            key: Form_key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset("assets/images/l1.png",width: 130,height: 130,),
                ),
                SizedBox(
                  width: 20, height: 20,
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
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!value.contains("@") || !value.contains(".")) {
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
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pass,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Password";
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
                            if(con_password == true)
                            {
                              con_password = false;
                            }
                            else
                            {
                              con_password= true;
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (Form_key.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: email.text, password: pass.text)
                                .then((value) {
                              FirebaseFirestore.instance.collection("Admin").add({
                                "Username": name.text.trim(),
                                "Email": email.text.trim(),
                                "Password": pass.text.trim(),
                              });
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
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
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    }, child: Text("Join us Now >>"))
                  ],
                )
              ],
            )

        ),
      )

      ,
    );
  }
}

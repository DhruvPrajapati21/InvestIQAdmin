import 'package:flutter/material.dart';
import 'package:invest_iq/Admin.dart';
import 'package:invest_iq/Signup.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
final Form_key = GlobalKey<FormState>();

TextEditingController name1Controller = TextEditingController();
TextEditingController name2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.cyan,
      title:Center(child: Text("Invest-IQ",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),)),
    ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/images/Logo.png"),
              Image.asset("assets/images/g1.png",width: 110,height: 110,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.cyan,
                    labelText: 'Enter Your Email',
                    labelStyle: TextStyle(color: Colors.cyan),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: name2Controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Your Password',
                      labelStyle: TextStyle(color: Colors.cyan),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(Icons.remove_red_eye_rounded),
                    prefixIconColor: Colors.cyan,
                    suffixIconColor: Colors.cyan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
              ),
              SizedBox(width: double.infinity,
                child: ElevatedButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Admin()));
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 18),)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text("Need an account?"),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signup()));
                  }, child: Text("Join us >>")),
                ],
              )
            ],
          ),

        ),
      ),
    );

  }
}

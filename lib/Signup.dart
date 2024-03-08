import 'package:flutter/material.dart';
import 'package:invest_iq/Login.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}
  class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child: Text("Invest-IQ",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),),),
      ),
      body:SingleChildScrollView(
        child: Center(
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
                  decoration: InputDecoration(
                      labelText: 'Enter Your Password',
                      prefixIcon: Icon(Icons.password),
                      prefixIconColor: Colors.cyan,
                      suffixIcon: Icon(Icons.remove_red_eye_outlined),
                      suffixIconColor: Colors.cyan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter Your Conform Password',
                      prefixIcon: Icon(Icons.password),
                      prefixIconColor: Colors.cyan,
                      suffixIcon: Icon(Icons.remove_red_eye_outlined),
                      suffixIconColor: Colors.cyan,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: ElevatedButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan,foregroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),

                    child: Text("Sign Up",style: TextStyle(fontSize: 18),)),
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

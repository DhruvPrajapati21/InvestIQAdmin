import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invest_iq/Login.dart';
class Spacescreen extends StatefulWidget {
  const Spacescreen({super.key});

  @override
  State<Spacescreen> createState() => _SpacescreenState();

}

class _SpacescreenState extends State<Spacescreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4 ),(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body:
       Center(
         child: Padding(
           padding: const EdgeInsets.only(top: 150),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Image.asset("assets/images/Logo.png"),
               Image.asset("assets/images/m1.png",height: 20,width: 20,),

               SizedBox(width: 20,height: 20,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                   TextButton(onPressed: (){

                   }, child: Text("Welcome!",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 26,color: Colors.cyan),)),
                       SizedBox(width: 10,height: 10,),
                         ],
                       ),
                  CircularProgressIndicator(),
               SizedBox(width: 50,height: 50,),
             ],
           ),
         ),
       ),
     );
  }
}

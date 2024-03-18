import 'package:flutter/material.dart';
class Allusers extends StatefulWidget {
  const Allusers({super.key});

  @override
  State<Allusers> createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("All Users Data", style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        ),
        centerTitle: true,
      ),
    );
  }
}

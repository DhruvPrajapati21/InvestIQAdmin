import 'package:flutter/material.dart';
import 'package:invest_iq/AddData.dart';
import 'package:invest_iq/AddGuidelines.dart';
import 'package:invest_iq/FreeGuidelines/Freeguidelines.dart';
import 'package:invest_iq/IPO/IPO.dart';
import 'package:invest_iq/Intrday/Intraday.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/All Users/Allusers.dart';
import 'package:invest_iq/AddIPO.dart';
import 'package:invest_iq/Intrday/Intraday.dart';


class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Invest-IQ",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    backgroundImage:
                    AssetImage('assets/images/Logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text("Add Data"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddData()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_chart),
              title: const Text("Add  IPO"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddIPO()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_2_rounded),
              title: const Text("Add Guidelines"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddGuidelines()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddIPO()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              onTap: () {
              },
            ),

          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
          ),
          Text(
            "Invest-IQ Admin",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  height: 180,
                  width: 180,
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Intraday()));
                    },
                    child: Card(
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 25.0,
                        margin: EdgeInsets.all(10.0),
                        shadowColor: Colors.black12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/u4.png",
                              height: 70,
                              width: 70,
                            ),
                            SizedBox(height: 10),
                            Text("IntraDay",style: TextStyle(color: Colors.white,fontSize: 16)),
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 180,
                  width: 180,
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Shortterm()));
                    },

                  child: Card(
                    color: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    elevation: 25.0,
                    margin: EdgeInsets.all(10.0),
                    shadowColor: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/x2.png",
                            height: 60, width: 60),
                        SizedBox(height: 10),
                        Text("Short Term",style: TextStyle(color: Colors.white,fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                                )],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                height: 180,
                width: 180,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Longterm()));
                  },
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 25.0,
                  margin: EdgeInsets.all(10.0),
                  shadowColor: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/u2.png",
                          height: 50, width: 50),
                      SizedBox(height: 10),
                      Text("Long Term",style: TextStyle(color: Colors.white,fontSize: 16)),
                    ],
                  ),
                ),
              ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 180,
                width: 180,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => IPO()));
                  },
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 25.0,
                  margin: EdgeInsets.all(10.0),
                  shadowColor: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/x4.png",
                          height: 50, width: 50),
                      SizedBox(height: 10),
                      Text("IPO",style: TextStyle(color: Colors.white,fontSize: 16)),
                    ],
                  ),
                ),
              ),
              )],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Container(
                height: 180,
                width: 180,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Allusers()));
                  },
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 25.0,
                  margin: EdgeInsets.all(10.0),
                  shadowColor: Colors.black12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/x5.png",
                          height: 50, width: 50),
                      SizedBox(height: 10),
                      Text("All Users",style: TextStyle(color: Colors.white,fontSize: 16)),
                    ],
                  ),
                ),
              ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 180,
                width: 180,
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Freeguidelines()));
                  },
                child: Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 25.0,
                  margin: EdgeInsets.all(10.0),
                  shadowColor: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/u3.png",
                          height: 50, width: 50),
                      SizedBox(height: 10),
                      Text("Free Guidelines",style: TextStyle(color: Colors.white,fontSize: 16),),
                    ],
                  ),
                ),
              ),
              )],
          ),
        ],
      ),
    );
  }
}

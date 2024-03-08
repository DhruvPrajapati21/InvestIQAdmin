import 'package:flutter/material.dart';
import 'package:invest_iq/AddData.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:invest_iq/FreeGuidelines/AddGuidelines.dart';
import 'package:invest_iq/FreeGuidelines/Freeguidelines.dart';
import 'package:invest_iq/IPO/IPO.dart';
import 'package:invest_iq/Intrday/Intraday.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/All Users/Allusers.dart';
import 'package:invest_iq/IPO/AddIPO.dart';
import 'package:invest_iq/Intrday/Intraday.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                      (route) => false,
                );
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      height: 180,
      width: 180,
      child: GestureDetector(
        onTap: () {
          // Navigate to the corresponding screen
        },
        child: Card(
          color: Colors.white70,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 10.0,
          margin: EdgeInsets.all(10.0),
          shadowColor: Colors.black87,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    color: Colors.white,
                  ),
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
                      backgroundImage: AssetImage('assets/images/Logo.png'),
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
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddData()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_chart),
                title: const Text("Add IPO"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddIPO()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_2_rounded),
                title: const Text("Add Guidelines"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddGuidelines()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notification_add),
                title: const Text("Notifications"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  showLogoutConfirmationDialog(context);
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
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Intraday()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/u4.png",
                            height: 70,
                            width: 70,
                          ),
                          SizedBox(height: 10),
                          Text("IntraDay",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Shortterm()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/x2.png", height: 60, width: 60),
                          SizedBox(height: 10),
                          Text("Short Term",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Longterm()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/u2.png", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("Long Term",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => IPO()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/x4.png", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("IPO",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Allusers()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/x5.png", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("All Users",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _buildCard(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Freeguidelines()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/u3.png", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("Free Guidelines",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

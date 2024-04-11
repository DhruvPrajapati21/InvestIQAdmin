import 'package:flutter/material.dart';
import 'package:invest_iq/AddData.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:invest_iq/FreeGuidelines/AddGuidelines.dart';
import 'package:invest_iq/FreeGuidelines/Freeguidelines.dart';
import 'package:invest_iq/IPO/IPO.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:invest_iq/Notifications.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/All Users/Allusers.dart';
import 'package:invest_iq/IPO/AddIPO.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'Provider.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool _isDialogShowing = false;

  Future<bool> _onWillPop() async {
    if (_isDialogShowing) {
      return false; // Return false if dialog is already showing
    }

    // Set the flag to indicate the dialog is being shown
    _isDialogShowing = true;

    bool? confirmExit = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog with back button
      builder: (context) => AlertDialog(
        title: const Text('Exit Invest-IQ?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        content: const Text('Are you sure you want to exit?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        actions: [
          TextButton(
            onPressed: () {
              // Reset the flag and dismiss the dialog with false result
              setState(() {
                _isDialogShowing = false;
              });
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Reset the flag and dismiss the dialog with true result
              setState(() {
                _isDialogShowing = false;
              });
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    // Return the result of the dialog or false if dialog was dismissed
    return confirmExit ?? false;
  }
  Widget _buildCard(Widget child, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 180,
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



  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Invest-IQ?",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
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
          ],
        );
      },
    );
  }

  Widget _buildCard1(Widget child) {
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
          title: Text(
            "Invest-IQ",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          width: 220,
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
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
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
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text("Add Data"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddData()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.add_chart),
                title: const Text("Add IPO"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddIPO()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.announcement),
                title: const Text("Add Guidelines"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddGuidelines()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.notification_add),
                title: const Text("Notifications"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.sunny_snowing,size: 25,),
                title: const Text("Theme"),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
              ),
              const Divider(thickness: 2,),
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
                    Column(
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
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Intraday()),
                      );
                    },
                  ),
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/x2.png", height: 60, width: 60),
                        SizedBox(height: 10),
                        Text("Short Term",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Shortterm()),
                      );
                    },
                  ),
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/u2.png", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("Long Term",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Longterm()),
                      );
                    },
                  ),
                  _buildCard(
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/x4.png", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("IPO",
                              style: TextStyle(color: Colors.black, fontSize: 16)),
                        ]
                    ),
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IPO()),
                      );
                    },
                  ),
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/x5.png", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("All Users", style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Allusers()),
                      );
                    },
                  ),

                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/u3.png", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("Free Guidelines",
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Freeguidelines()),
                      );
                    },
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
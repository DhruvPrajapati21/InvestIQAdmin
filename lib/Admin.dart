import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/AddData.dart';
import 'package:invest_iq/AuthView/Login.dart';
import 'package:invest_iq/FreeGuidelines/AddGuidelines.dart';
import 'package:invest_iq/FreeGuidelines/Freeguidelines.dart';
import 'package:invest_iq/IPO/IPO.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/All Users/Allusers.dart';
import 'package:invest_iq/IPO/AddIPO.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Provider.dart';
import 'notifications/Notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setPersistence(Persistence.NONE);

  // Check if the user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  Widget homeScreen = user != null ? Admin() : Login();

  runApp(MyApp(homeScreen: homeScreen));
}


class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDialogShowing = false;

  Future<bool> _onWillPop() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openEndDrawer();
      return false; // Prevent default back button behavior
    } else if (!_isDialogShowing) {
      _isDialogShowing = true;
      bool? confirmExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Exit Invest-IQ?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          content: const Text('Are you sure you want to exit?', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          actions: [
            TextButton(
              onPressed: () {
                _isDialogShowing = false; // Reset _isDialogShowing before closing the dialog
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _isDialogShowing = false; // Reset _isDialogShowing before closing the dialog
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      return confirmExit ?? false;
    } else {
      return false; // Prevent default back button behavior
    }
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
        key: _scaffoldKey,
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
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Admin()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.add_box),
                title: const Text("Add Data"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddData()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.add_chart),
                title: const Text("Add IPO"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AddIPO()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.announcement),
                title: const Text("Add Guidelines"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddGuidelines()));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.notification_add),
                title: const Text("Notifications"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications(id: '',)));
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.sunny_snowing,size: 25,),
                title: const Text("Theme"),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  Navigator.pop(context);
                },
              ),
              const Divider(thickness: 2,),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pop(context);
                  showLogoutConfirmationDialog(context);
                },
              ),
              const Divider(thickness: 2,),
            ],
          ),
        ),
        body:SingleChildScrollView(
          child:Column(
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
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  _buildCard(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/s9.svg",
                          height: 70,
                          width: 70,
                        ),
                        SizedBox(height: 10),
                        Text("IntraDay",
                            style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
                        SvgPicture.asset("assets/images/x8.svg", height: 60, width: 60),
                        SizedBox(height: 10),
                        Text("Short Term",
                            style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
                        SvgPicture.asset("assets/images/z7.svg", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("Long Term",
                            style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
                          SvgPicture.asset("assets/images/z4.svg", height: 50, width: 50),
                          SizedBox(height: 10),
                          Text("IPO",
                              style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
                        SvgPicture.asset("assets/images/z5.svg", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("All Users", style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
                        SvgPicture.asset("assets/images/z6.svg", height: 50, width: 50),
                        SizedBox(height: 10),
                        Text("Free Guidelines",
                            style: TextStyle(color: Colors.black, fontSize: 16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
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
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/All Users/AllUsersModel.dart';
import 'package:invest_iq/AuthView/Splashscreen.dart';
import 'package:invest_iq/Admin.dart';

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
        title: Text(
          "All Users Data",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.home, size: 25, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Admin()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .snapshots(), // Fetch only 'IntraDay' category.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          List<AllUsersModel> Users = snapshot.data!.docs
              .map((doc) => AllUsersModel.fromSnapshot(doc))
              .toList();
          List<AllUsersModel> UserData = [];
          snapshot.data!.docs.forEach((doc) {
            AllUsersModel Username = AllUsersModel.fromSnapshot(doc);
            AllUsersModel Email = AllUsersModel.fromSnapshot(doc);
            AllUsersModel Password = AllUsersModel.fromSnapshot(doc);

            UserData.add(Username);
            UserData.add(Email);
            UserData.add(Password);
          });

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var AllUsersModel = Users[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white60,
                  margin: EdgeInsets.all(11.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.cyan,
                      radius: 15,
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${AllUsersModel.Username}',style: TextStyle(color: Colors.black),),
                          SizedBox(height: 10),
                          Text('Email: ${AllUsersModel.Email}',style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(snapshot.data!.docs[index].id)
                                            .delete();
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                          msg: "Item Deleted Successfully",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.cyan,
                                          textColor: Colors.white,
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

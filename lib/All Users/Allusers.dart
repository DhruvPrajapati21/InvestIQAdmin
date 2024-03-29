import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invest_iq/All Users/AllUsersModel.dart';
import 'package:invest_iq/AuthView/Spacescreen.dart';

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
                    leading: CircleAvatar( backgroundColor: Colors.cyan,radius: 15,
                      child: Text((index + 1).toString(),style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),), // Displaying the index number
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${AllUsersModel.Username}',
                          ),
                          SizedBox(height: 10),
                          Text('Email: ${AllUsersModel.Email}'),
                          SizedBox(height: 10),
                          Text(
                            'Password: ${AllUsersModel.Password}',
                          ),
                        ],
                      ),
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

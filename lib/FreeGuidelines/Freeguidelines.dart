import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invest_iq/FreeGuidelines/Editfreeguidelinesscreen.dart';
import 'package:invest_iq/FreeGuidelines/GuidelinesModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/Admin.dart';

class Freeguidelines extends StatefulWidget {
  const Freeguidelines({super.key});

  @override
  State<Freeguidelines> createState() => _FreeguidelinesState();
}

class _FreeguidelinesState extends State<Freeguidelines> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Free Guidelines",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Guidelines').snapshots(), // Fetch only 'IntraDay' category.snapshots(),
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
          List<GuidelinesModel> Guidelines = snapshot.data!.docs.map((doc) => GuidelinesModel.fromSnapshot(doc)).toList();
          List<GuidelinesModel> Guide = [];
          snapshot.data!.docs.forEach((doc) {
            GuidelinesModel headlines = GuidelinesModel.fromSnapshot(doc);
            GuidelinesModel guidelines = GuidelinesModel.fromSnapshot(doc);
            GuidelinesModel contactus = GuidelinesModel.fromSnapshot(doc);

            Guide.add(headlines);
            Guide.add(guidelines);
            Guide.add(contactus);
          });

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var GuidelinesModel = Guidelines[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white60,
                  margin: EdgeInsets.all(11.0),
                  child: ListTile(
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${GuidelinesModel.headlines}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30),
                          Text('${GuidelinesModel.guidelines}'),
                          SizedBox(height: 30),
                          Text(
                            '${GuidelinesModel.contactus}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.teal),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Editfreeguidelinesscreen(
                                  documentId: snapshot.data!.docs[index].id,
                                ),
                              ),
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

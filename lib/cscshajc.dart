import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/IPO/IPOModel.dart';
import 'package:invest_iq/IPO/EditIPOScreen.dart';
import 'package:invest_iq/Admin.dart';

class IPO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'IPO Data',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.home, size: 25, color: Colors.white),
        //     onPressed: () {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => Admin()),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('IPO').snapshots(),
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
          List<IPOModel> IPO = snapshot.data!.docs
              .map((doc) => IPOModel.fromSnapshot(doc))
              .toList();

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var IPOModel = IPO[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white60,
                  margin: EdgeInsets.all(11.0),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${IPOModel.status}'),
                        Text('Stock Name: ${IPOModel.stockName.trim()}'),
                        Text('Lot: ${IPOModel.lot.trim()}'),
                        Text('Price: ${IPOModel.price.trim()}'),
                        Text('Open Date: ${IPOModel.opendate}'),
                        Text('Close Date: ${IPOModel.closedate}'),
                        Text('Remark: ${IPOModel.remark.trim()}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
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
                                            .collection('IPO')
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
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditIPOScreen(
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/IPO/IPOModel.dart';
import 'package:invest_iq/IPO/EditIPOScreen.dart';
import 'package:invest_iq/Admin.dart';

class IPO extends StatelessWidget {
  Future<String?> getImageUrlFromFirebase(String documentId) async {
    try {
      // Fetch the document snapshot using the document ID
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('IPO').doc(documentId).get();
      // Extract the image URL from the document snapshot
      return documentSnapshot.get('imageUrl');
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }



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
                  color: Colors.white,
                  margin: EdgeInsets.all(11.0),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${IPOModel.status}',style: TextStyle(color: Colors.black),),
                        Text('Stock Name: ${IPOModel.stockName.trim()}',style: TextStyle(color: Colors.black),),
                        Text('Lot: ${IPOModel.lot.trim()}',style: TextStyle(color: Colors.black),),
                        Text('Price: ${IPOModel.price.trim()}',style: TextStyle(color: Colors.black),),
                        Text('Open Date: ${IPOModel.opendate}',style: TextStyle(color: Colors.black),),
                        Text('Close Date: ${IPOModel.closedate}',style: TextStyle(color: Colors.black),),
                        Text('Remark: ${IPOModel.remark.trim()}',style: TextStyle(color: Colors.black),),
                        Card(
                          surfaceTintColor: Colors.cyan,
                          elevation: 8.0,
                          shadowColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black, width: 1.0),
                          ),
                          margin: EdgeInsets.all(10.0),
                          child: FutureBuilder<String?>(
                            future: getImageUrlFromFirebase(snapshot.data!.docs[index].id), // Pass the document ID
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                String imageUrl = snapshot.data ?? ''; // Use default value if imageUrl is null
                                if (imageUrl.isEmpty) {
                                  return Container(); // Return an empty container if imageUrl is empty or still being fetched
                                }
                                return Container(
                                  height: 120,
                                  width: 120,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) => Text('Error loading image: $error'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
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
                          onPressed: () async {
                            String imageUrl = await getImageUrlFromFirebase(IPOModel.documentId) ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditIPOScreen(
                                  documentId: snapshot.data!.docs[index].id,
                                  Image: imageUrl, // Pass the image URL here
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

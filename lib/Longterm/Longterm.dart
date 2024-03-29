// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:invest_iq/Longterm/Editlongtermscreen.dart';
//
//
// class Longterm extends StatefulWidget {
//   const Longterm({Key? key}) : super(key: key);
//
//   @override
//   State<Longterm> createState() => _LongtermState();
// }
//
// class _LongtermState extends State<Longterm> {
//   bool _isSaving = false;
//   void _deleteCategory(String categoryID) {
//     FirebaseFirestore.instance
//         .collection('Stocks')
//         .doc(categoryID)
//         .delete()
//         .then((value) {
//       // Show a toast message when a category is deleted successfully
//       Fluttertoast.showToast(
//         msg: 'Category deleted successfully',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.cyan,
//         textColor: Colors.white,
//       );
//     }).catchError((error) {
//       // Show a toast message when there is an error deleting the category
//       Fluttertoast.showToast(
//         msg: 'Failed to delete category',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.cyan,
//         textColor: Colors.white,
//       );
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: Center(
//           child: Text(
//             "Long Term",
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Stocks')
//             .where('category', isEqualTo: 'Long Term') // Fetch only 'Long Term' category
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           List<DocumentSnapshot> documents = snapshot.data!.docs;
//
//           if (documents.isEmpty) {
//             return Center(
//               child: Text('No short term stocks available.'),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               var data = documents[index].data();
//               return Card(
//                 color: Colors.lightBlueAccent,
//                 shape:RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50.0)),
//                 elevation: 25.0,
//                 margin: EdgeInsets.all(10.0),
//                 shadowColor: Colors.black,
//                 child: ListTile(
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Category: ${data??['category']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('Status: ${data??['status']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('Stock Name: ${data??['stockName']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('CMP: ${data??['cmp']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('Target: ${data??['target']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('SL: ${data??['sl']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('Remark: ${data??['remark']}'),
//                       SizedBox(height: 5,width: 5,),
//                       Text('Date: ${data??['date']}'),
//                       SizedBox(height: 5,width: 5,),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.delete,color: Colors.red,),
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text("Confirm Delete"),
//                                 content: Text(
//                                     "Are you sure you want to delete this item?"),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text("Cancel"),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       FirebaseFirestore.instance.collection(
//                                           'Stocks')
//                                           .doc(documents[index].id)
//                                           .delete();
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: Text("Delete"),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.edit,color: Colors.teal,),
//                         onPressed: () {
//                           // Navigate to edit screen and pass the document ID
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Editlongtermscreen(
//                                 documentId: documents[index].id,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invest_iq/Longterm/Editlongtermscreen.dart';
import 'package:invest_iq/StatusModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:intl/intl.dart';

class Longterm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('LongTerm Data',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Stocks')
            .where('category', isEqualTo: 'Long Term')
            .snapshots(),// Fetch only 'IntraDay' category.snapshots(),
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
          List<StatusModel> stocks = snapshot.data!.docs.map((doc) => StatusModel.fromSnapshot(doc)).toList();
          List<StatusModel> Stocks = [];
          snapshot.data!.docs.forEach((doc) {
            StatusModel category = StatusModel.fromSnapshot(doc);
            StatusModel status = StatusModel.fromSnapshot(doc);
            StatusModel stockName = StatusModel.fromSnapshot(doc);
            StatusModel cmp = StatusModel.fromSnapshot(doc);
            StatusModel target = StatusModel.fromSnapshot(doc);
            StatusModel sl = StatusModel.fromSnapshot(doc);
            StatusModel remark = StatusModel.fromSnapshot(doc);
            StatusModel date = StatusModel.fromSnapshot(doc);


            Stocks.add(category);
            Stocks.add(status);
            Stocks.add(stockName);
            Stocks.add(cmp);
            Stocks.add(target);
            Stocks.add(sl);
            Stocks.add(remark);
            Stocks.add(date);

          });

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var statusModel = stocks[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white60,
                  margin: EdgeInsets.all(11.0),
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${statusModel.category}'),
                        Text('Status: ${statusModel.status}'),
                        Text('Stock Name: ${statusModel.stockName}'),
                        Text('CMP: ${statusModel.cmp}'),
                        Text('Target: ${statusModel.target}'),
                        Text('SL: ${statusModel.sl}'),
                        Text('Remark: ${statusModel.remark}'),
                        Text('Date: ${statusModel.date}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
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
                                            .collection('Stocks')
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
                          icon: Icon(Icons.edit,color: Colors.teal,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Editlongtermscreen(
                                  documentId:snapshot.data!.docs [index].id,
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

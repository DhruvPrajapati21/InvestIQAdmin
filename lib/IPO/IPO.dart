// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Intraday extends StatefulWidget {
//   const Intraday({Key? key}) : super(key: key);
//
//   @override
//   State<Intraday> createState() => _IntradayState();
// }
//
// class _IntradayState extends State<Intraday> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: Center(
//           child: Text(
//             "IntraDay",
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
//             .where('category', isEqualTo: 'IntraDay') // Fetch only 'IntraDay' category
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
//                           // Implement edit functionality here
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invest_iq/IPO/IPOModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/IPO/EditIPOScreen.dart';
import 'package:invest_iq/Admin.dart';

class IPO extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child:Text('IPO Data',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('IPO')
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
          List<IPOModel> Ipo = snapshot.data!.docs.map((doc) => IPOModel.fromSnapshot(doc)).toList();
          List<IPOModel> IPO = [];
          snapshot.data!.docs.forEach((doc) {
            IPOModel status = IPOModel.fromSnapshot(doc);
            IPOModel stockName = IPOModel.fromSnapshot(doc);
            IPOModel lot = IPOModel.fromSnapshot(doc);
            IPOModel price = IPOModel.fromSnapshot(doc);
            IPOModel opendate = IPOModel.fromSnapshot(doc);
            IPOModel closedate = IPOModel.fromSnapshot(doc);
            IPOModel remark = IPOModel.fromSnapshot(doc);


            IPO.add(status);
            IPO.add(stockName);
            IPO.add(lot);
            IPO.add(price);
            IPO.add(opendate);
            IPO.add(closedate);
            IPO.add(remark);

          });

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var IPOModel = Ipo[index];
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
                        Text('Open Date: ${IPOModel.opendate.trim()}'),
                        Text('Close Date: ${IPOModel.closedate.trim()}'),
                        Text('Remark: ${IPOModel.remark.trim()}'),
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
                          icon: Icon(Icons.edit,color: Colors.teal,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditIPOScreen(
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

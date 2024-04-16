import 'package:cloud_firestore/cloud_firestore.dart';

class IPOModel {
  final String documentId; // Add documentId property

  // Other properties
  final String status;
  final String stockName;
  final String lot;
  final String price;
  final String opendate;
  final String closedate;
  final String remark;

  IPOModel({
    required this.documentId, // Include documentId in the constructor
    required this.status,
    required this.stockName,
    required this.lot,
    required this.price,
    required this.opendate,
    required this.closedate,
    required this.remark,
  });

  factory IPOModel.fromSnapshot(DocumentSnapshot doc) {
    // Extract document ID from the document snapshot
    String documentId = doc.id;
    // Extract other fields from the document snapshot
    String status = doc['status'];
    String stockName = doc['stockName'];
    String lot = doc['lot'];
    String price = doc['price'];
    String opendate = doc['opendate'];
    String closedate = doc['closedate'];
    String remark = doc['remark'];

    return IPOModel(
      documentId: documentId, // Pass documentId to the constructor
      status: status,
      stockName: stockName,
      lot: lot,
      price: price,
      opendate: opendate,
      closedate: closedate,
      remark: remark,
    );
  }
}

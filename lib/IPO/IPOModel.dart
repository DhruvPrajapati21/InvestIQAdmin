import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IPOModel {
  // Add the id field
  final String status;
  final String stockName;
  final String lot;
  final String price;
  final String opendate;
  final String closedate;
  final String remark;

  IPOModel(
      {required this.status,required this.stockName ,required this.lot,required this.price,required this.opendate,required this.closedate,required this.remark,});

  factory IPOModel.fromSnapshot(DocumentSnapshot snapshot) {
    return IPOModel(
      // Assign the document ID to the id field
      status: snapshot['status'],
      stockName: snapshot['stockName'],
      lot: snapshot['lot'],
      price: snapshot['price'],
      opendate: snapshot['opendate'],
      closedate: snapshot['closedate'],
      remark: snapshot['remark']
    );
  }
}

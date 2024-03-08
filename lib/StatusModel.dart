import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  final String category; // Add the id field
  final String status;
  final String stockName;
  final String cmp;
  final String target;
  final String sl;
  final String remark;
  final String date;



  StatusModel(
      {required this.category,required this.status ,required this.stockName,required this.cmp,required this.target,required this.sl,required this.remark,required this.date,});

  factory StatusModel.fromSnapshot(DocumentSnapshot snapshot) {
    return StatusModel(
      category: snapshot['category'],// Assign the document ID to the id field
      status: snapshot['status'],
      stockName: snapshot['stockName'],
      cmp: snapshot['cmp'],
      target: snapshot['target'],
      sl: snapshot['sl'],
      remark: snapshot['remark'],
      date: snapshot['date'],



    );
  }
}

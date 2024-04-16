import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class StatusModel {
  final String documentId;
  final String category; // Add the id field
  final String status;
  final String stockName;
  final String cmp;
  final String target;
  final String sl;
  final String remark;
  final String date;


  StatusModel(
      {required this.documentId,required this.category,required this.status ,required this.stockName,required this.cmp,required this.target,required this.sl,required this.remark,required this.date,});

  factory StatusModel.fromSnapshot(DocumentSnapshot doc) {
    String documentId = doc.id;
    String category = doc['category'];
    String status = doc['status'];
    String stockName = doc['stockName'];
    String cmp = doc['cmp'];
    String target = doc['target'];
    String sl = doc['sl'];
    String remark = doc['remark'];
    String date = doc['date'];

    return StatusModel(
      documentId: documentId,
      category: category,// Assign the document ID to the id field
      status: status,
      stockName: stockName,
      cmp: cmp,
      target: target,
      sl: sl,
      remark: remark,
      date: date,

    );
  }
}

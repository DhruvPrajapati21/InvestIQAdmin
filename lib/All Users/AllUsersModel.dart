import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsersModel {
  // Add the id field
  final String Username;
  final String Email;


  AllUsersModel(
      {required this.Username,required this.Email});

  factory AllUsersModel.fromSnapshot(DocumentSnapshot snapshot) {
    return AllUsersModel(
      // Assign the document ID to the id field
      Username: snapshot['Username'],
      Email: snapshot['Email'],
    );
  }
}

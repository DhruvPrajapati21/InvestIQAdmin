import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class AddGuidelines extends StatefulWidget {
  const AddGuidelines({super.key});

  @override
  State<AddGuidelines> createState() => _AddGuidelinesState();
}

class _AddGuidelinesState extends State<AddGuidelines> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController headlinesController = TextEditingController();
  TextEditingController guidelinesController = TextEditingController();
  TextEditingController contactusController = TextEditingController();

  Future<void> _addToFirestore() async {
    if (_validateFields()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Check if the stock name is already present in the selected category
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('Guidelines')
            .where('headlines', isEqualTo: headlinesController.text)
            .where('guidelines', isEqualTo: guidelinesController.text)
            .where('contactus', isEqualTo: contactusController.text)

            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Stock name already exists in the selected category, show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status name already exists in the selected status.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Stock name is unique in the selected category, proceed to add data
          await _firestore.collection('Guidelines').add({
            'headlines': headlinesController.text,
            'guidelines': guidelinesController.text,
            'contactus': contactusController.text,
          });

          // Reset values after successful data addition
          setState(() {
            headlinesController.clear();
            guidelinesController.clear();
            contactusController.clear();
          });

          // Show success message in Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data added to Firestore successfully!'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Handle errors
        print('Error adding data to Firestore: $e');

        // Show error message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add data to Firestore. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Show a Snackbar when fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields must be filled.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  bool _validateFields() {
    return
          headlinesController.text.isNotEmpty &&
          guidelinesController.text.isNotEmpty &&
          contactusController.text.isNotEmpty;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Center(child: Text("Guidelines Form",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.white),),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: headlinesController,
                    decoration: InputDecoration(
                      labelText: 'Headings',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
                    Padding(
            padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: guidelinesController,
            maxLines:6, // Allow multiple lines
            keyboardType: TextInputType.multiline, // Enable multiline input
            decoration: InputDecoration(
              labelText: 'Guidelines',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
                Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: contactusController,
            maxLines:2, // Allow multiple lines
            keyboardType: TextInputType.multiline, // Enable multiline input
            decoration: InputDecoration(
              labelText: 'Contact us',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    _addToFirestore();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Upload Guidelines!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/FreeGuidelines/GuidelinesModel.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/Admin.dart';
class Editfreeguidelinesscreen extends StatefulWidget {
  final String documentId;

  const Editfreeguidelinesscreen({Key? key, required this.documentId})
      : super(key: key);

  @override
  _EditfreeguidelinesscreenState createState() => _EditfreeguidelinesscreenState();
}

class _EditfreeguidelinesscreenState extends State<Editfreeguidelinesscreen> {

  // Define TextEditingController for each field
  final TextEditingController headlinesController = TextEditingController();
  final TextEditingController guidelinesController = TextEditingController();
  final TextEditingController contactusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch existing data from Firestore and populate the fields
    FirebaseFirestore.instance
        .collection('Guidelines')
        .doc(widget.documentId)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          headlinesController.text = doc['headlines'];
          guidelinesController.text = doc['guidelines'];
          contactusController.text = doc['contactus'];
        });
      }
    }).catchError((error) {
      print("Failed to fetch document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Edit Guidelines Data",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onPressed: () {
                      if (
                         headlinesController.text.trim().isEmpty ||
                         guidelinesController.text.trim().isEmpty ||
                             contactusController.text.trim().isEmpty)
                           {
                        // Display an error message if any required field is empty
                        Fluttertoast.showToast(
                          msg: 'All fields must be filled',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.cyan,
                          textColor: Colors.white,
                        );
                      } else {
                        // All required fields are filled, proceed with updating Firestore document
                        setState(() {
                        });
                        // Update Firestore document with new data
                        FirebaseFirestore.instance
                            .collection('Guidelines')
                            .doc(widget.documentId)
                            .update({
                          'headlines': headlinesController.text.trim(),
                          'guidelines': guidelinesController.text.trim(),
                          'contactus': contactusController.text.trim(),
                        }).then((_) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: 'Data Updated Successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.white,
                          );// Close the edit screen
                        }).catchError((error) {
                          bool _isSaving = false;

                          // Handle error
                          print("Failed to update document: $error");
                          setState(() {
                            _isSaving = false;
                          });
                        });
                      }
                    },
                    child: Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

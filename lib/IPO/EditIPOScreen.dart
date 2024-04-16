import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/IPO/IPOModel.dart';
import 'package:invest_iq/IPO/IPO.dart';
import 'package:invest_iq/Admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class EditIPOScreen extends StatefulWidget {
  final String documentId;
  final String Image;
  const EditIPOScreen({super.key, required this.documentId,required this.Image});

  @override
  State<EditIPOScreen> createState() => _EditIPOScreenState();
}

class _EditIPOScreenState extends State<EditIPOScreen> {
  List<String> ipo = ['Status', 'All', 'Current', 'Upcoming'];
  String? selectedIPO = 'Status';
  DateTime? selectedDate;
  DateTime? selectedDate2;
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  // Define TextEditingController for each field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController stockNameController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController remarkController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate2) {
      setState(() {
        selectedDate2 = pickedDate;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    // Fetch existing data from Firestore and populate the fields
    FirebaseFirestore.instance.collection('IPO').doc(widget.documentId).get().then((doc) {
      if (doc.exists) {
        setState(() {
          selectedIPO = doc['status'];
          stockNameController.text = doc['stockName'];
          lotController.text = doc['lot'];
          priceController.text = doc['price'];
          selectedDate = DateTime.parse(doc['opendate']);
          selectedDate2 = DateTime.parse(doc['closedate']);
          remarkController.text = doc['remark'];
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
          "Edit IPO Data",
          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.home, size: 25, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Admin()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.network(
                widget.Image, // Use widget.Image instead of widget.image
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),
              SizedBox(

                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child: ElevatedButton(
                    onPressed: isLoading // Disable button if loading
                        ? null
                        : () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (file != null) {
                        selectedImage = File(file.path);
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor:Colors.cyan,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                    child: const Text("Select Image",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
                    ),
                  ),
                  value: selectedIPO,
                  items: ipo.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: TextStyle(fontSize: 18)),
                  )).toList(),
                  onChanged: (item) => setState(() => selectedIPO = item),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: stockNameController,
                  decoration: InputDecoration(
                    labelText: 'Stock Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: lotController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Lot',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : 'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                  ),
                  decoration: InputDecoration(
                    labelText: "Opening Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  readOnly: true,
                  onTap: () {
                    _selectDate2(context);
                  },
                  controller: TextEditingController(
                    text: selectedDate2 == null
                        ? ''
                        : 'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate2!)}',
                  ),
                  decoration: InputDecoration(
                    labelText: "Closing Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDate2(context);
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () async {
                      // Check if any of the required fields are empty
                      if (selectedIPO == null ||
                          stockNameController.text.trim().isEmpty ||
                          lotController.text.trim().isEmpty ||
                          priceController.text.trim().isEmpty ||
                          selectedDate == null ||
                          selectedDate2 == null ||
                          remarkController.text.trim().isEmpty) {
                        // Display an error message if any required field is empty
                        Fluttertoast.showToast(
                          msg: 'All fields must be filled',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      } else {
                        // All required fields are filled, proceed with updating Firestore document
                        setState(() {
                          isLoading = true; // Set loading state to true
                        });

                        try {
                          // Check if a new image is selected
                          if (selectedImage != null) {
                            // Upload the new image to Firebase Storage
                            String imageUrl = await uploadImageToStorage(selectedImage!);
                            // Update the image URL in Firestore
                            await FirebaseFirestore.instance.collection('IPO').doc(widget.documentId).update({
                              'imageUrl': imageUrl,
                            });
                          }

                          // Convert DateTime objects to formatted date strings
                          String formattedDate = selectedDate!.toLocal().toString().split(' ')[0];
                          String formattedDate2 = selectedDate2!.toLocal().toString().split(' ')[0];

                          // Update Firestore document with new data
                          await FirebaseFirestore.instance.collection('IPO').doc(widget.documentId).update({
                            'status': selectedIPO,
                            'stockName': stockNameController.text.trim(),
                            'lot': lotController.text.trim(),
                            'price': priceController.text.trim(),
                            'opendate': formattedDate,
                            'closedate': formattedDate2,
                            'remark': remarkController.text.trim(),
                          });

                          // Show success message
                          Fluttertoast.showToast(
                            msg: 'Data Updated Successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.white,
                          );

                          // Navigate back to the previous screen
                          Navigator.pop(context);
                        } catch (error) {
                          // Handle errors
                          print("Failed to update document: $error");
                          // Show error message
                          Fluttertoast.showToast(
                            msg: 'Failed to update data. Please try again.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        } finally {
                          // Set loading state to false
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
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

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('IPO_images');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }
}

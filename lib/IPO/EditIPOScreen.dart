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
  bool isNavigatingToLogin = true;
  // Define TextEditingController for each field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController stockNameController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    }
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate2 ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate2) {
      setState(() {
        selectedDate2 = pickedDate;
        // Update the text in the dateController to reflect the new selected date
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate2!);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('IPO')
          .doc(widget.documentId)
          .get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      selectedIPO = doc['status'];
      stockNameController.text = doc['stockName'];
      lotController.text = doc['lot'];
      priceController.text = doc['price'];
      remarkController.text = doc['remark'];

      // Handle the 'opendate' and 'closedate' fields correctly
      if (data['opendate'] is String) {
        // If it's a String, parse it as a DateTime
        selectedDate = DateFormat('dd/MM/yyyy').parse(data['opendate']);
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      } else if (data['opendate'] is Timestamp) {
        // If it's a Timestamp, convert it to a DateTime
        Timestamp timestamp = data['opendate'] as Timestamp;
        selectedDate = timestamp.toDate();
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      }

      // Handle the 'closedate' field in a similar manner
      if (data['closedate'] is String) {
        selectedDate2 = DateFormat('dd/MM/yyyy').parse(data['closedate']);
      } else if (data['closedate'] is Timestamp) {
        Timestamp timestamp = data['closedate'] as Timestamp;
        selectedDate2 = timestamp.toDate();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
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
                      borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface), // Set the same color as enabled border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // Change border color to white for dark theme
                            : Colors.black, // Change border color to black for light theme
                      ),// Set the same color as enabled border
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please wait..."),
                            duration: Duration(seconds: 2), // Adjust the duration as needed
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds
                        setState(() {
                          isNavigatingToLogin = true;
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

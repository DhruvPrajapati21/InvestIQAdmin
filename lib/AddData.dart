import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/Admin.dart';
import 'package:image_picker/image_picker.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  List<String> items = ['Category', 'IntraDay', 'Short Term', 'Long Term'];
  String? selectedOption = 'Category';

  List<String> items1 = [
    'Status',
    'Active',
    'Achieved',
    'SL Hit',
  ];
  String? selectedStatus = 'Status';
  DateTime? selectedDate;
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController stockNameController = TextEditingController();
  TextEditingController cmpController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController slController = TextEditingController();
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _addToFirestore() async {
    if (_validateFields()) {
      setState(() {
        isLoading = true;
      });
      try {
        // Upload the image to Firebase Storage first
        String imagePath = '';
        if (selectedImage != null) {
          // Create a reference to the location you want to upload to in Firebase Storage
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('images')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

          // Upload the file to Firebase Storage
          UploadTask uploadTask = ref.putFile(selectedImage!);

          // Get the download URL of the uploaded file
          TaskSnapshot snapshot = await uploadTask;
          imagePath = await snapshot.ref.getDownloadURL();
        }

        // Proceed to add other data to Firestore
        String formattedDate = _formatDate(selectedDate!);
        await _firestore.collection('Stocks').add({
          'category': selectedOption,
          'status': selectedStatus,
          'stockName': stockNameController.text.trim(),
          'cmp': cmpController.text.trim(),
          'target': targetController.text.trim(),
          'sl': slController.text.trim(),
          'remark': remarkController.text.trim(),
          'date': formattedDate,
          'imageUrl': imagePath, // Add the image URL to Firestore
        });

        // Reset values after successful data addition
        setState(() {
          selectedOption = null;
          selectedStatus = null;
          selectedDate = null;
          selectedImage = null;
          stockNameController.clear();
          cmpController.clear();
          targetController.clear();
          slController.clear();
          remarkController.clear();
        });

        // Show success message in Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data added to Firestore successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
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
    return selectedDate != null &&
        selectedOption != null &&
        selectedStatus != null &&
        stockNameController.text.trim().isNotEmpty &&
        cmpController.text.trim().isNotEmpty &&
        targetController.text.trim().isNotEmpty &&
        slController.text.isNotEmpty &&
        remarkController.text.trim().isNotEmpty &&
        selectedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "New Stock",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                selectedImage != null
                    ? Image.file(selectedImage!, width: 200, height: 200)
                    : Image.asset("assets/images/mp.png",
                        width: 100, height: 100),
                // const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: ElevatedButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file == null) return;
                        selectedImage = File(file.path);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      child: const Text(
                        "Select Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                        ),
                      ),
                    ),
                    value: selectedOption,
                    items: items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item, style: TextStyle(fontSize: 18)),
                          ),
                        )
                        .toList(),
                    onChanged: (item) => setState(() => selectedOption = item),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                        ),
                      ),
                    ),
                    value: selectedStatus,
                    items: items1
                        .map((item1) => DropdownMenuItem<String>(
                              value: item1,
                              child:
                                  Text(item1, style: TextStyle(fontSize: 18)),
                            ))
                        .toList(),
                    onChanged: (item1) =>
                        setState(() => selectedStatus = item1),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    controller: stockNameController,
                    decoration: InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    controller: cmpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'CMP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Target',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    controller: slController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'SL',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
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
                        )),
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
                      labelText: "Select Date",
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
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedImage == null) {
                          // If no image is selected, show a message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an image.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          // If an image is selected, proceed to add data
                          _addToFirestore();
                        }
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
                              "Submit",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
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

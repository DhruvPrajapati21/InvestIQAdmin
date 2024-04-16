import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/StatusModel.dart';
import 'package:invest_iq/Admin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
class Editlongtermscreen extends StatefulWidget {
  final String documentId;
  final String imageUrl;
  const Editlongtermscreen({Key? key, required this.documentId,required this.imageUrl}) : super(key: key);

  @override
  _EditlongtermscreenState createState() => _EditlongtermscreenState();
}

class _EditlongtermscreenState extends State<Editlongtermscreen> {
  List<String> items = [ 'Category','IntraDay', 'Short Term', 'Long Term'];
  String? selectedOption = 'Category';

  List<String> status = ['Status','Active', 'Achieved', 'SL Hit',];
  String? selectedstatus = 'Status';
  DateTime? selectedDate;
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  // Define TextEditingController for each field
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _stockNameController = TextEditingController();
  final TextEditingController _cmpController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _slController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();


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

      DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('Stocks').doc(widget.documentId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      _categoryController.text = data['category'];
      _statusController.text = data['status'];
      _stockNameController.text = data['stockName'];
      _cmpController.text = data['cmp'];
      _targetController.text = data['target'];
      _slController.text = data['sl'];
      _remarkController.text = data['remark'];
      selectedDate = doc['date'] != null ? DateTime.parse(doc['date']) : null;

      setState(() {
        isLoading = false;
      }); // Update the state to reflect changes
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Edit LongTerm Data",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white),
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
                widget.imageUrl, // Use widget.Image instead of widget.image
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 1, color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
                    ),
                  ),
                  value: selectedOption,
                  items: items
                      .map((item) =>
                      DropdownMenuItem<String>
                        (value: item,
                        child: Text(item, style: TextStyle(fontSize: 18)),
                      ))
                      .toList(),
                  onChanged: (item) => setState(() => selectedOption = item),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 1, color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
                    ),
                  ),
                  value: selectedstatus,
                  items: status
                      .map((item) =>
                      DropdownMenuItem<String>
                        (value: item,
                        child: Text(item, style: TextStyle(fontSize: 18)),
                      ))
                      .toList(),
                  onChanged: (item) => setState(() => selectedstatus = item),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _stockNameController,
                  decoration: InputDecoration(
                      labelText: 'Stock Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _cmpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'CMP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Target',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _slController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'SL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _remarkController,
                  decoration: InputDecoration(
                      labelText: 'Remark',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
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

              SizedBox(height: 20),

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
                    onPressed: () async {
                      if (selectedOption == null ||
                          selectedstatus == null ||
                          _stockNameController.text.trim().isEmpty ||
                          _cmpController.text.trim().isEmpty ||
                          _targetController.text.trim().isEmpty ||
                          _slController.text.trim().isEmpty ||
                          _remarkController.text.trim().isEmpty ||
                          selectedDate == null) {
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
                          isLoading = true; // Set loading state to true
                        });

                        try {
                          // Check if a new image is selected
                          if (selectedImage != null) {
                            // Upload the new image to Firebase Storage
                            String imageUrl = await uploadImageToStorage(
                                selectedImage!);
                            // Update the image URL in Firestore
                            await FirebaseFirestore.instance.collection('Stocks')
                                .doc(widget.documentId)
                                .update({
                              'imageUrl': imageUrl,
                            });
                          }
                          String formattedDate = _formatDate(selectedDate!);
                          // Update Firestore document with new data
                          await FirebaseFirestore.instance
                              .collection('Stocks')
                              .doc(widget.documentId)
                              .update({
                            'category': selectedOption,
                            'status': selectedstatus,
                            'stockName': _stockNameController.text.trim(),
                            'cmp': _cmpController.text.trim(),
                            'target': _targetController.text.trim(),
                            'sl': _slController.text.trim(),
                            'remark': _remarkController.text.trim(),
                            'date': formattedDate,
                          });
                          // Navigate back and show success message
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: 'Data Updated Successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.white,
                          );
                          if (selectedOption == 'Short Term') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  Shortterm()),
                            );
                          } else if (selectedOption == 'IntraDay') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Intraday()),
                            );
                          } // Close the edit screen
                        } catch (error) {
                          // Handle error
                          print("Failed to update document: $error");
                          setState(() {
                            isLoading = false;
                          });
                        }
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
Future<String> uploadImageToStorage(File imageFile) async {
  Reference storageRef = FirebaseStorage.instance.ref().child('Longterm_images');
  await storageRef.putFile(imageFile);
  return await storageRef.getDownloadURL();
}
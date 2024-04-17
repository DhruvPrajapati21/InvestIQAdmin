import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/Admin.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddIPO extends StatefulWidget {
  const AddIPO({Key? key}) : super(key: key);

  @override
  State<AddIPO> createState() => _AddIPOState();
}

class _AddIPOState extends State<AddIPO> {
  List<String> ipo = ['Status', 'All', 'Current', 'Upcoming'];
  String? selectedIPO = 'Status';
  DateTime? selectedDate;
  DateTime? selectedDate2;
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController stockNameController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
          Reference ref = FirebaseStorage.instance.ref().child('images').child('${DateTime.now().millisecondsSinceEpoch}.jpg');

          // Upload the file to Firebase Storage
          UploadTask uploadTask = ref.putFile(selectedImage!);

          // Get the download URL of the uploaded file
          TaskSnapshot snapshot = await uploadTask;
          imagePath = await snapshot.ref.getDownloadURL();
        }
        // Format selected dates
        String formattedDate = _formatDate(selectedDate!);
        String formattedDate2 = _formatDate(selectedDate2!);

        // Check if the stock name is already present in the selected category
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('IPO')
            .where('status', isEqualTo: selectedIPO)
            .where('stockName', isEqualTo: stockNameController.text.trim())
            .where('lot', isEqualTo: lotController.text.trim())
            .where('price', isEqualTo: priceController.text.trim())
            .where('opendate', isEqualTo: formattedDate)
            .where('closedate', isEqualTo: formattedDate2)
            .where('remark', isEqualTo: remarkController.text.trim())
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
          await _firestore.collection('IPO').add({
            'status': selectedIPO,
            'stockName': stockNameController.text.trim(),
            'lot': lotController.text.trim(),
            'price': priceController.text.trim(),
            'opendate': formattedDate,
            'closedate': formattedDate2,
            'remark': remarkController.text.trim(),
            'imageUrl': imagePath,
          });

          // Reset values after successful data addition
          setState(() {
            selectedIPO = null;
            selectedImage= null;
            stockNameController.clear();
            lotController.clear();
            priceController.clear();
            selectedDate = null;
            selectedDate2 = null;
            remarkController.clear();
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
    return selectedIPO != null &&
        stockNameController.text.trim().isNotEmpty &&
        lotController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        selectedDate != null &&
        selectedDate2 != null &&
        remarkController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          "Adding IPO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
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
                    : Image.asset("assets/images/mp.png", width: 100, height: 100),
                // const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: ElevatedButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                        if (file == null) return;
                        selectedImage = File(file.path);
                        setState(() {});
                      },style: ElevatedButton.styleFrom(backgroundColor:Colors.cyan,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                      child: const Text("Select Image",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ), // Set the border color based on the current theme
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
                    value: selectedIPO,
                    items: ipo
                        .map(
                          (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 18)),
                      ),
                    )
                        .toList(),
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
                    keyboardType: TextInputType.number,
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
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
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

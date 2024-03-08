import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:invest_iq/Admin.dart';

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
  bool isLoading = false;
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

  Future<void> _addToFirestore() async {
    if (_validateFields()) {
      setState(() {
        isLoading = true;
      });

      try {
        String formattedDate = selectedDate!.toLocal().toString().split(' ')[0];
        String formattedDate2 = selectedDate2!.toLocal().toString().split(' ')[0];
        // Check if the stock name is already present in the selected category
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('IPO')
            .where('status', isEqualTo: selectedIPO)
            .where('stockName', isEqualTo: stockNameController.text.trim())
            .where('lot', isEqualTo: lotController.text.trim())
            .where('price', isEqualTo: priceController.text.trim())
            .where('opendate', isEqualTo: selectedDate)
            .where('closedate', isEqualTo: selectedDate2)
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
          String formattedDate = selectedDate!.toLocal().toString().split(' ')[0];
          String formattedDate2 = selectedDate2!.toLocal().toString().split(' ')[0];
          // Stock name is unique in the selected category, proceed to add data
          await _firestore.collection('IPO').add({
            'status': selectedIPO,
            'stockName': stockNameController.text.trim(),
            'lot': lotController.text.trim(),
            'price': priceController.text.trim(),
            'opendate': formattedDate.trim(),
            'closedate': formattedDate2.trim(),
            'remark': remarkController.text.trim(),
          });

          // Reset values after successful data addition
          setState(() {
            selectedIPO = 'Status';
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
        title: Center(
          child: Text(
            "Adding IPO",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 1, color: Colors.black),
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
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : 'Selected Date: ${selectedDate!.toString().substring(0, 10)}',
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
                  readOnly: true,
                  onTap: () {
                    _selectDate2(context);
                  },
                  controller: TextEditingController(
                    text: selectedDate2 == null
                        ? ''
                        : 'Selected Date: ${selectedDate2!.toString().substring(0, 10)}',
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
    );
  }
}

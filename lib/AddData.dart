import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  List<String> items = ['Category', 'IntraDay', 'Short Term', 'Long Term'];
  String? selectedOption = 'Category';

  List<String> items1 = ['Status','Active', 'Achieved', 'SL Hit',];
  String? selectedStatus = 'Status';
  DateTime? selectedDate;
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

  Future<void> _addToFirestore() async {
    if (_validateFields()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Check if the stock name is already present in the selected category
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('Stocks')
            .where('category', isEqualTo: selectedOption)
            .where('stockName', isEqualTo: stockNameController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Stock name already exists in the selected category, show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stock name already exists in the selected category.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Convert selectedDate to a formatted string
          String formattedDate = selectedDate!.toLocal().toString().split(' ')[0];

          // Stock name is unique in the selected category, proceed to add data
          await _firestore.collection('Stocks').add({
            'category': selectedOption,
            'status': selectedStatus,
            'stockName': stockNameController.text,
            'cmp': cmpController.text,
            'target': targetController.text,
            'sl': slController.text,
            'remark': remarkController.text,
            'date': formattedDate, // Store date as string
          });

          // Reset values after successful data addition
          setState(() {
            selectedOption = null;
            selectedStatus = null;
            selectedDate = null;
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
    return selectedOption != null &&
        selectedStatus != null &&
        stockNameController.text.isNotEmpty &&
        cmpController.text.isNotEmpty &&
        targetController.text.isNotEmpty &&
        slController.text.isNotEmpty &&
        remarkController.text.isNotEmpty &&
        selectedDate != null;
  }


      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: Center(child: Text("New Stock", style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white),),),
          ),
          body: SingleChildScrollView(
          child:Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 1, color: Colors.black)
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
                    ),
                    value: selectedStatus,
                    items: items1
                        .map((item1) =>
                        DropdownMenuItem<String>
                          (value: item1,
                          child: Text(item1, style: TextStyle(fontSize: 18)),
                        ))
                        .toList(),
                    onChanged: (item1) => setState(() => selectedStatus = item1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: stockNameController,
                    decoration: InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cmpController,
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
                    controller: targetController,
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
                    controller: slController,
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
                    controller: remarkController,
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
                ElevatedButton(onPressed: () async  {
                  _addToFirestore();
                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white,) // Show the progress indicator
                      : const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),

                ),
              ],
            ),
          ),
        ),
        );
      }
    }

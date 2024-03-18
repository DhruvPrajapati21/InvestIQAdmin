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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
            .where('stockName', isEqualTo: stockNameController.text.trim())
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
          // Format the selected date
          String formattedDate = _formatDate(selectedDate!);

          // Stock name is unique in the selected category, proceed to add data
          await _firestore.collection('Stocks').add({
            'category': selectedOption,
            'status': selectedStatus,
            'stockName': stockNameController.text.trim(),
            'cmp': cmpController.text.trim(),
            'target': targetController.text.trim(),
            'sl': slController.text.trim(),
            'remark': remarkController.text.trim(),
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
            title: Text("New Stock", style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            ),
            centerTitle: true,
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
                    keyboardType: TextInputType.numberWithOptions(),
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
                    keyboardType: TextInputType.numberWithOptions(),
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
                    keyboardType: TextInputType.numberWithOptions(),
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
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: ElevatedButton(onPressed: () async  {
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
                  ),
                ),
              ],
            ),
          ),
        ),
        );
      }
    }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/IPO/IPOModel.dart';
import 'package:invest_iq/IPO/IPO.dart';

class EditIPOScreen extends StatefulWidget {
  final String documentId;
  const EditIPOScreen({super.key, required this.documentId});

  @override
  State<EditIPOScreen> createState() => _EditIPOScreenState();
}

class _EditIPOScreenState extends State<EditIPOScreen> {
  List<String> ipo = ['Status', 'All', 'Current', 'Upcoming'];
  String? selectedIPO = 'Status';
  DateTime? selectedDate;
  DateTime? selectedDate2;
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                    onPressed: () {
                      // Check if any of the required fields are empty
                      if (selectedIPO == null ||
                          stockNameController.text
                .trim()
                .isEmpty ||
                          lotController.text
                .trim()
                .isEmpty ||
                          priceController.text
                .trim()
                .isEmpty ||
                          selectedDate == null ||
                          selectedDate2 == null ||
                      remarkController.text.trim().isEmpty)
                      {
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
                        bool _isSaving = false;
                        setState(() {
                          _isSaving = true;
                        });
                        // Convert DateTime objects to Timestamp objects
                        String formattedDate = selectedDate!.toLocal().toString().split(' ')[0];
                        String formattedDate2 = selectedDate2!.toLocal().toString().split(
                            ' ')[0];
                        // Update Firestore document with new data
                        FirebaseFirestore.instance.collection('IPO')
                            .doc(widget.documentId)
                            .update({
                          'status': selectedIPO,
                          'stockName': stockNameController.text.trim(),
                          'lot': lotController.text.trim(),
                          'price': priceController.text.trim(),
                          'opendate': formattedDate,
                          'closedate': formattedDate2,
                          'remark': remarkController.text.trim(),
                        }).then((_) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: 'Data Updated Successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.cyan,
                            textColor: Colors.white,
                          );
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
    );
  }
}

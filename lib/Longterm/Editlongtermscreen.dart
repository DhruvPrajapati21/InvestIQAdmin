import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/Intraday/Intraday.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/StatusModel.dart';
class Editlongtermscreen extends StatefulWidget {
  final String documentId;

  const Editlongtermscreen({Key? key, required this.documentId}) : super(key: key);

  @override
  _EditlongtermscreenState createState() => _EditlongtermscreenState();
}

class _EditlongtermscreenState extends State<Editlongtermscreen> {
  List<String> items = [ 'Category','IntraDay', 'Short Term', 'Long Term'];
  String? selectedOption = 'Category';

  List<String> status = ['Status','Active', 'Achieved', 'SL Hit',];
  String? selectedstatus = 'Status';
  DateTime? selectedDate;
  // Define TextEditingController for each field
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _stockNameController = TextEditingController();
  final TextEditingController _cmpController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _slController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Fetch existing data from Firestore and populate the fields
    FirebaseFirestore.instance.collection('Stocks').doc(widget.documentId).get().then((doc) {
      if (doc.exists) {
        setState(() {
          selectedOption = doc['category'];
          selectedstatus = doc['status'];
          _stockNameController.text = doc['stockName'];
          _cmpController.text = doc['cmp'];
          _targetController.text = doc['target'];
          _slController.text = doc['sl'];
          _remarkController.text = doc['remark'];
          selectedDate = DateTime.parse(doc['date']);
        });
      }
    }).catchError((error) {
      print("Failed to fetch document: $error");
    });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Edit LongTerm Data",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                controller: _cmpController,
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
                controller: _targetController,
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
                controller: _slController,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  onPressed: () {
                    if (selectedOption == null ||
                        selectedstatus == null ||
                        _stockNameController.text
                            .trim()
                            .isEmpty ||
                        _cmpController.text
                            .trim()
                            .isEmpty ||
                        _targetController.text
                            .trim()
                            .isEmpty ||
                        _slController.text
                            .trim()
                            .isEmpty ||
                        _remarkController.text
                            .trim()
                            .isEmpty ||
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
                      bool _isSaving = false;
                      setState(() {
                        _isSaving = true;
                      });

                      String formattedDate = selectedDate!.toLocal()
                          .toString()
                          .split(' ')[0];
                      // Update Firestore document with new data
                      FirebaseFirestore.instance.collection('Stocks')
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
                      }).then((_) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: 'Data Updated Successfully',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
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
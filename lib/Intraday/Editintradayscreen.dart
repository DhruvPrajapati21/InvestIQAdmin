import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';
import 'package:invest_iq/Longterm/Longterm.dart';
import 'package:invest_iq/StatusModel.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/Admin.dart';
class Editintradayscreen extends StatefulWidget {
  final String documentId;

  const Editintradayscreen({Key? key, required this.documentId})
      : super(key: key);

  @override
  _EditintradayscreenState createState() => _EditintradayscreenState();
}

class _EditintradayscreenState extends State<Editintradayscreen> {
  List<String> items = ['Category', 'IntraDay', 'Short Term', 'Long Term'];
  String? selectedOption = 'Category';

  List<String> status = [
    'Status',
    'Active',
    'Achieved',
    'SL Hit',
  ];
  String? selectedstatus = 'Status';
  DateTime? selectedDate;
  // Define TextEditingController for each field
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _stockNameController = TextEditingController();
  final TextEditingController _cmpController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _slController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isLoading = false; // Added loading indicator state

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
          .collection('Stocks')
          .doc(widget.documentId)
          .get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          selectedOption = doc['category'];
          selectedstatus = doc['status'];
          _stockNameController.text = doc['stockName'];
          _cmpController.text = doc['cmp'];
          _targetController.text = doc['target'];
          _slController.text = doc['sl'];
          _remarkController.text = doc['remark'];
      // Handle the 'date' field correctly
      if (data['date'] is String) {
        // If it's a String, parse it as a DateTime
        selectedDate = DateTime.parse(data['date']);
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      } else if (data['date'] is Timestamp) {
        // If it's a Timestamp, convert it to a DateTime
        Timestamp timestamp = data['date'] as Timestamp;
        selectedDate = timestamp.toDate();
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      }

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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // Update the text in the dateController to reflect the new selected date
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
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
        title: Text(
          "Edit IntraDay Data",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
                  ),
                  ),
                value: selectedOption,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item, style: TextStyle(fontSize: 18)),
                        ))
                    .toList(),
                onChanged: (item) => setState(() => selectedOption = item),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
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
                    )),
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
                    )),
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
                    )),
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
                    )),
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
                  onPressed: () {
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
                      });
                      String formattedDate = _formatDate(selectedDate!);
                      // Update Firestore document with new data
                      FirebaseFirestore.instance
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
                      }).then((_) {
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
                            MaterialPageRoute(
                                builder: (context) => Shortterm()),
                          );
                        } else if (selectedOption == 'Long Term') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Longterm()),
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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:invest_iq/Intraday/Intraday.dart';
// import 'package:invest_iq/Longterm/Longterm.dart';
// import 'package:invest_iq/StatusModel.dart';
// import 'package:intl/intl.dart';
// class Editshortermscreen extends StatefulWidget {
//   final String documentId;
//
//   const Editshortermscreen({Key? key, required this.documentId}) : super(key: key);
//
//   @override
//   _EditshortermscreenState createState() => _EditshortermscreenState();
// }
//
// class _EditshortermscreenState extends State<Editshortermscreen> {
//   List<String> items = [ 'Category','IntraDay', 'Short Term', 'Long Term'];
//   String? selectedOption = 'Category';
//
//   List<String> status = ['Status','Active', 'Achieved', 'SL Hit',];
//   String? selectedstatus = 'Status';
//   DateTime? selectedDate;
//   // Define TextEditingController for each field
//   final TextEditingController _statusController = TextEditingController();
//   final TextEditingController _stockNameController = TextEditingController();
//   final TextEditingController _cmpController = TextEditingController();
//   final TextEditingController _targetController = TextEditingController();
//   final TextEditingController _slController = TextEditingController();
//   final TextEditingController _remarkController = TextEditingController();
//
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch existing data from Firestore and populate the fields
//     FirebaseFirestore.instance.collection('Stocks').doc(widget.documentId).get().then((doc) {
//       if (doc.exists) {
//         setState(() {
//           selectedOption = doc['category'];
//           selectedstatus = doc['status'];
//           _stockNameController.text = doc['stockName'];
//           _cmpController.text = doc['cmp'];
//           _targetController.text = doc['target'];
//           _slController.text = doc['sl'];
//           _remarkController.text = doc['remark'];
//           selectedDate = doc['date'] != null ? DateTime.parse(doc['date']) : null;
//         });
//       }
//     }).catchError((error) {
//       print("Failed to fetch document: $error");
//     });
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: Text("Edit ShortTerm Data",style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 10, vertical: 10),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(width: 1, color: Colors.black)
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
//                   ),
//                 ),
//                 value: selectedOption,
//                 items: items
//                     .map((item) =>
//                     DropdownMenuItem<String>
//                       (value: item,
//                       child: Text(item, style: TextStyle(fontSize: 18)),
//                     ))
//                     .toList(),
//                 onChanged: (item) => setState(() => selectedOption = item),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 10, vertical: 10),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(width: 1, color: Colors.black)
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide(width: 1, color: Colors.black), // Set the same color as enabled border
//                   ),
//                 ),
//                 value: selectedstatus,
//                 items: status
//                     .map((item) =>
//                     DropdownMenuItem<String>
//                       (value: item,
//                       child: Text(item, style: TextStyle(fontSize: 18)),
//                     ))
//                     .toList(),
//                 onChanged: (item) => setState(() => selectedstatus = item),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 controller: _stockNameController,
//                 decoration: InputDecoration(
//                     labelText: 'Stock Name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 controller: _cmpController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                     labelText: 'CMP',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 controller: _targetController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                     labelText: 'Target',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 controller: _slController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                     labelText: 'SL',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 controller: _remarkController,
//                 decoration: InputDecoration(
//                     labelText: 'Remark',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     )
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 textInputAction: TextInputAction.next,
//                 onEditingComplete: () => FocusScope.of(context).nextFocus(),
//                 readOnly: true,
//                 onTap: () {
//                   _selectDate(context);
//                 },
//                 controller: TextEditingController(
//                   text: selectedDate == null
//                       ? ''
//                       : 'Selected Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
//                 ),
//                 decoration: InputDecoration(
//                   labelText: "Select Date",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       _selectDate(context);
//                     },
//                     icon: Icon(Icons.calendar_today),
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.cyan,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5.0))),
//                   onPressed: () {
//                     if (selectedOption == null ||
//                         selectedstatus == null ||
//                         _stockNameController.text
//                             .trim()
//                             .isEmpty ||
//                         _cmpController.text
//                             .trim()
//                             .isEmpty ||
//                         _targetController.text
//                             .trim()
//                             .isEmpty ||
//                         _slController.text
//                             .trim()
//                             .isEmpty ||
//                         _remarkController.text
//                             .trim()
//                             .isEmpty ||
//                         selectedDate == null) {
//                       // Display an error message if any required field is empty
//                       Fluttertoast.showToast(
//                         msg: 'All fields must be filled',
//                         toastLength: Toast.LENGTH_SHORT,
//                         gravity: ToastGravity.BOTTOM,
//                         backgroundColor: Colors.cyan,
//                         textColor: Colors.white,
//                       );
//                     } else {
//                       // All required fields are filled, proceed with updating Firestore document
//                       bool _isSaving = false;
//                       setState(() {
//                         _isSaving = true;
//                       });
//
//                       String formattedDate = selectedDate!.toLocal()
//                           .toString()
//                           .split(' ')[0];
//                       // Update Firestore document with new data
//                       FirebaseFirestore.instance.collection('Stocks')
//                           .doc(widget.documentId)
//                           .update({
//                         'category': selectedOption,
//                         'status': selectedstatus,
//                         'stockName': _stockNameController.text.trim(),
//                         'cmp': _cmpController.text.trim(),
//                         'target': _targetController.text.trim(),
//                         'sl': _slController.text.trim(),
//                         'remark': _remarkController.text.trim(),
//                         'date': formattedDate,
//                       }).then((_) {
//                         Navigator.pop(context);
//                         Fluttertoast.showToast(
//                           msg: 'Data Updated Successfully',
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           backgroundColor: Colors.green,
//                           textColor: Colors.white,
//                         );
//                         if (selectedOption == 'IntraDay') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) =>
//                                 Intraday()),
//                           );
//                         } else if (selectedOption == 'Long Term') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => Longterm()),
//                           );
//                         } // Close the edit screen
//                       }).catchError((error) {
//                         bool _isSaving = false;
//
//                         // Handle error
//                         print("Failed to update document: $error");
//                         setState(() {
//                           _isSaving = false;
//                         });
//                       });
//                     }
//                   },
//                   child: Text(
//                     "Save Changes",
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// EditIntraDayScreen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:invest_iq/Shortterm/Shortterm.dart';

class EditShortTermScreen extends StatefulWidget {
  final String documentId;

  const EditShortTermScreen({Key? key, required this.documentId})
      : super(key: key);

  @override
  _EditShortTermScreenState createState() => _EditShortTermScreenState();
}

class _EditShortTermScreenState extends State<EditShortTermScreen> {
  TextEditingController stockNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController cmpController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController slController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<String> categories = ['IntraDay', 'ShortTerm', 'LongTerm'];
  List<String> statusOptions = ['Active', 'Achieved', 'SL Hit'];

  DateTime? selectedDate;

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

      stockNameController.text = data['stockName'];
      categoryController.text = data['category'];
      statusController.text = data['status'];
      cmpController.text = data['cmp'];
      targetController.text = data['target'];
      slController.text = data['sl'];
      remarkController.text = data['remark'];

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

  Future<void> updateData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Check if any of the required fields are empty after trimming whitespace
      if (stockNameController.text.trim().isEmpty ||
          categoryController.text.trim().isEmpty ||
          statusController.text.trim().isEmpty ||
          cmpController.text.trim().isEmpty ||
          targetController.text.trim().isEmpty ||
          slController.text.trim().isEmpty ||
          remarkController.text.trim().isEmpty ||
          selectedDate == null) {
        // Show an error message if any of the required fields are empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Proceed with the update if all required fields are filled
      await FirebaseFirestore.instance
          .collection('Stocks')
          .doc(widget.documentId)
          .update({
        'stockName': stockNameController.text,
        'category': categoryController.text,
        'status': statusController.text,
        'cmp': cmpController.text,
        'target': targetController.text,
        'sl': slController.text,
        'remark': remarkController.text,
        'date': selectedDate,
      });

      // Fetch updated data after the update is successful
      await _fetchData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context); // Go back to the previous screen after updating
    } catch (e) {
      print('Error updating data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit ShortTerm',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: categoryController.text.isNotEmpty
                  ? categoryController.text
                  : null,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoryController.text = value ?? '';
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: statusController.text.isNotEmpty
                  ? statusController.text
                  : null,
              items: statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  statusController.text = value ?? '';
                });
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: stockNameController,
              decoration: InputDecoration(
                labelText: 'Stock Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: cmpController,
              decoration: InputDecoration(
                labelText: 'CMP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: targetController,
              decoration: InputDecoration(
                labelText: 'Target',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: slController,
              decoration: InputDecoration(
                labelText: 'SL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: remarkController,
              decoration: InputDecoration(
                labelText: 'Remark',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                labelText: 'Date',
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () => selectDate(context),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateData,
              style: ElevatedButton.styleFrom(
                backgroundColor: CupertinoColors.systemBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : const Text(
                'Update!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

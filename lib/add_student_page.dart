import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _datetimeController = TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;

  // ➕ ADD STUDENT FUNCTION
  void _addStudent() async {
    if (_nameController.text.isEmpty ||
        _numberController.text.isEmpty ||
        selectedGender == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    await FirebaseFirestore.instance.collection('students').add({
      'name': _nameController.text,
      'number': _numberController.text,
      'gender': selectedGender,
      'datetime': Timestamp.fromDate(selectedDate!), // ⭐ FIXED
    });

    _nameController.clear();
    _numberController.clear();
    _datetimeController.clear();
    setState(() {
      selectedGender = null;
      selectedDate = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Student added successfully')));
  }

  // 📅 DATE PICKER
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Calendar text color
            ),
            dialogBackgroundColor: Colors.white, // Background
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _datetimeController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Add Student", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // NAME
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Name",
                  ),
                  controller: _nameController,
                ),
              ),
            ),

            SizedBox(height: 10),

            // NUMBER
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Number",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                ),
              ),
            ),

            SizedBox(height: 10),

            // GENDER
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Gender",
                  ),
                  items:
                      ['Male', 'Female', 'Other']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 10),

            // DATE
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Select Date",
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                  controller: _datetimeController,
                  readOnly: true,
                  onTap: _pickDate,
                ),
              ),
            ),

            SizedBox(height: 20),

            // BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: GestureDetector(
                onTap: _addStudent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 20,
                    ),
                    child: Text(
                      "Add Student",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            // ElevatedButton(onPressed: _addStudent, child: Text("Add Student")),
          ],
        ),
      ),
    );
  }
}

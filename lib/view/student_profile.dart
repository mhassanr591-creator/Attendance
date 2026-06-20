import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studendNumber;
  final Timestamp studendDate;
  final Timestamp studentDob;
  final String studendGender;
  // final String studentImage;

  StudentProfile({
    required this.studentId,
    required this.studentName,
    required this.studendNumber,
    required this.studendDate,
    required this.studentDob,
    required this.studendGender,
    // required this.studentImage,
  });

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController datetimeController;
  late TextEditingController dobController;
  late TextEditingController genderController;

  String? selectedGender;
  DateTime? selectedDob;
  DateTime? selectedDate;
  // late TextEditingController imageController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.studentName);
    numberController = TextEditingController(text: widget.studendNumber);

    selectedGender = widget.studendGender;

    selectedDate = widget.studendDate.toDate();

    datetimeController = TextEditingController(
      text: "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
    );

    selectedDob = widget.studentDob.toDate();

    dobController = TextEditingController(
      text: "${selectedDob!.day}-${selectedDob!.month}-${selectedDob!.year}",
    );
  }
  // void initState() {
  //   super.initState();

  //   nameController = TextEditingController(text: widget.studentName);
  //   numberController = TextEditingController(text: widget.studendNumber);
  //   genderController = TextEditingController(text: widget.studendGender);

  //   // ⭐ ADD THIS HERE (IMPORTANT)
  //   try {
  //     Timestamp ts = widget.studendDate as Timestamp;
  //     selectedDate = ts.toDate();
  //     datetimeController = TextEditingController(
  //       text:
  //           "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
  //     );
  //   } catch (e) {
  //     selectedDate = widget.studendDate.toDate();

  //     datetimeController = TextEditingController(
  //       text:
  //           "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
  //     );
  //   }
  // }
  Future<void> _pickDobDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDob ?? DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    setState(() {
      selectedDob = picked;
      dobController.text =
          "${picked.day}-${picked.month}-${picked.year}";
    });
  }
}

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
        datetimeController.text =
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
        title: Text("Edit Student", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 👇 Profile Image Preview
              // CircleAvatar(
              //   radius: 40,
              //   backgroundImage: NetworkImage(imageController.text),
              // ),
              SizedBox(height: 10),
          
              // TextField(
              //   controller: imageController,
              //   decoration: InputDecoration(labelText: "Image URL"),
              //   onChanged: (_) {
              //     setState(() {}); // live preview update
              //   },
              // ),
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
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    keyboardType: TextInputType.number,
                    controller: numberController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Number",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    controller: datetimeController,
                    readOnly: true,
                    onTap: _pickDate,
                  ),
                ),
              ),
          
              SizedBox(height: 10),
          
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
                controller: dobController,
                readOnly: true,
                onTap: _pickDobDate,
                decoration: InputDecoration(
          border: InputBorder.none,
          labelText: "Date of Birth",
          suffixIcon: Icon(Icons.calendar_month),
                ),
              ),
            ),
          ),
          
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: GestureDetector(
                  onTap: _updateStudent,
          
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
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
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

  // ✅ UPDATE
  Future<void> _updateStudent() async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .update({
          'name': nameController.text,
          'number': numberController.text,
          'gender': selectedGender ?? genderController.text,
          'datetime':
              selectedDate != null
                  ? Timestamp.fromDate(selectedDate!)
                  : Timestamp.fromDate(DateTime.now()),
                  'DOB': Timestamp.fromDate(selectedDob!),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Updated Successfully")));

    Navigator.pop(context);
  }
  // ❌ DELETE

  void _confirmDelete(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Delete Student"),
          content: Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteStudent();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStudent() async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .delete();

    Navigator.pop(context);
  }
}

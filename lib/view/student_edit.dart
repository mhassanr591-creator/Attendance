import 'dart:ui';
import 'package:attendance/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentEdit extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studendNumber;
  final Timestamp studendDate;
  final Timestamp studentDob;
  final String studendGender;

  StudentEdit({
    required this.studentId,
    required this.studentName,
    required this.studendNumber,
    required this.studendDate,
    required this.studentDob,
    required this.studendGender,
  });

  @override
  _StudentEditState createState() => _StudentEditState();
}

class _StudentEditState extends State<StudentEdit> {
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController datetimeController;
  late TextEditingController dobController;

  String? selectedGender;
  DateTime? selectedDob;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.studentName);
    numberController = TextEditingController(text: widget.studendNumber);

    selectedGender = widget.studendGender;
    selectedDate = widget.studendDate.toDate();
    selectedDob = widget.studentDob.toDate();

    datetimeController = TextEditingController(
      text: "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
    );

    dobController = TextEditingController(
      text: "${selectedDob!.day}-${selectedDob!.month}-${selectedDob!.year}",
    );
  }

  /// 🌌 GLASS BOX
  Widget glassBox({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }

  /// 🌐 INPUT FIELD (REUSABLE)
  Widget inputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
  }) {
    return glassBox(
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF0F172A),
              onSurface: Colors.white,
            ),
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
        dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Student",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            inputField(label: "Name", controller: nameController),

            const SizedBox(height: 12),

            inputField(label: "Number", controller: numberController),

            const SizedBox(height: 12),

            /// GENDER
            glassBox(
              child: DropdownButtonFormField<String>(
                value: selectedGender,
                dropdownColor: const Color(0xFF0F172A),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Gender",
                  labelStyle: TextStyle(color: Colors.white70),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male", style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text(
                      "Female",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Other",
                    child: Text("Other", style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),
            ),

            const SizedBox(height: 12),

            inputField(
              label: "Joining Date",
              controller: datetimeController,
              readOnly: true,
              onTap: _pickDate,
              suffix: const Icon(Icons.calendar_month, color: Colors.white70),
            ),

            const SizedBox(height: 12),

            inputField(
              label: "Date of Birth",
              controller: dobController,
              readOnly: true,
              onTap: _pickDobDate,
              suffix: const Icon(Icons.calendar_month, color: Colors.white70),
            ),

            const SizedBox(height: 25),

            /// UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _updateStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Update Student",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 FUNCTIONALITY SAME (NO CHANGE)
  Future<void> _updateStudent() async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .update({
          'name': nameController.text,
          'number': numberController.text,
          'gender': selectedGender,
          'datetime': Timestamp.fromDate(selectedDate!),
          'DOB': Timestamp.fromDate(selectedDob!),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Updated Successfully")));

    Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  void _confirmDelete(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            "Delete Student",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Are you sure you want to delete this student?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseFirestore.instance
                    .collection('students')
                    .doc(widget.studentId)
                    .delete();
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}

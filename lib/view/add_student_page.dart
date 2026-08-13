import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:attendance/component/navbar.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _joiningController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? selectedGender;
  DateTime? joiningDate;
  DateTime? dobDate;

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _joiningController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  /// 🌌 GLASS CARD
  Widget glassBox({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }

  Future<void> _pickJoiningDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
            dialogBackgroundColor: const Color(0xFF0F172A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        joiningDate = picked;
        _joiningController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _pickDobDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF0F172A),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF0F172A),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dobDate = picked;
        _dobController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _addStudent() async {
    if (_nameController.text.trim().isEmpty ||
        _numberController.text.trim().isEmpty ||
        selectedGender == null ||
        joiningDate == null ||
        dobDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance.collection('students').add({
        'name': _nameController.text.trim(),
        'number': _numberController.text.trim(),
        'gender': selectedGender,
        'datetime': Timestamp.fromDate(joiningDate!),
        'DOB': Timestamp.fromDate(dobDate!),
        'isArchived': false,
        'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      });

      _nameController.clear();
      _numberController.clear();
      _joiningController.clear();
      _dobController.clear();

      setState(() {
        selectedGender = null;
        joiningDate = null;
        dobDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student added successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 🌐 INPUT FIELD
  Widget inputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return glassBox(
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add Student", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
          
                inputField(label: "Name", controller: _nameController),
          
                const SizedBox(height: 12),
          
                inputField(
                  label: "Number",
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                ),
          
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
                  controller: _joiningController,
                  readOnly: true,
                  onTap: _pickJoiningDate,
                  suffix: const Icon(Icons.calendar_month, color: Colors.white70),
                ),
          
                const SizedBox(height: 12),
          
                inputField(
                  label: "Date of Birth",
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDobDate,
                  suffix: const Icon(Icons.calendar_month, color: Colors.white70),
                ),
          
                const SizedBox(height: 25),
          
                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _addStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                              "Add Student",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
                SizedBox(height: 100,)
              ],
            ),
          ),
           Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Navbar(type: "Add")),
        ],
      ),
    );
  }
}

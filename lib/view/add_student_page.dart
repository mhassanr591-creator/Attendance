import 'package:attendance/component/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> _pickJoiningDate() async {
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
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance.collection('students').add({
        'name': _nameController.text.trim(),
        'number': _numberController.text.trim(),
        'gender': selectedGender,
        'datetime': Timestamp.fromDate(joiningDate!),
        'DOB': Timestamp.fromDate(dobDate!),
        'isArchived':false,
        'image':'https://images.unsplash.com/photo-1494790108377-be9c29b29330'
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE9E8E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Add Student", style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField(label: "Name", controller: _nameController),

              const SizedBox(height: 12),

              buildTextField(
                label: "Number",
                controller: _numberController,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 12),

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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Gender",
                    ),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              buildTextField(
                label: "Joining Date",
                controller: _joiningController,
                readOnly: true,
                onTap: _pickJoiningDate,
                suffixIcon: const Icon(Icons.calendar_month),
              ),

              const SizedBox(height: 12),

              buildTextField(
                label: "Date of Birth",
                controller: _dobController,
                readOnly: true,
                onTap: _pickDobDate,
                suffixIcon: const Icon(Icons.calendar_month),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _addStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Add Student",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(type: "Add"),
    );
  }
}

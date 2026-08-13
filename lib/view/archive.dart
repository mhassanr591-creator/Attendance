import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:attendance/component/navbar.dart';
import 'package:attendance/view/student_detail_page.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      /// BODY
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('students')
                .where('isArchived', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
          
              var students = snapshot.data!.docs;
          
              return Column(
                children: [
                  const SizedBox(height: 40),
          
                  /// HEADER
                  const Text(
                    "Archived Students",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          
                  const SizedBox(height: 10),
          
                  Text(
                    "Total: ${students.length}",
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
          
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: glassBox(
                            child: Row(
                              children: [
                                /// Index Badge
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.redAccent),
                                  ),
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
          
                                const SizedBox(width: 12),
          
                                /// NAME + ACTIONS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        student['name'] ?? "No Name",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
          
                                      const Text(
                                        "Archived Student",
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
          
                                /// OVERVIEW BUTTON
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.blueAccent.withOpacity(0.15),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StudentDetailPage(
                                          studentId: student.id,
                                          studentName: student['name'],
                                          studendNumber: student['number'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Overview",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
          
                                const SizedBox(width: 8),
          
                                /// UNARCHIVE BUTTON
                                IconButton(
                                  icon: const Icon(
                                    Icons.unarchive_outlined,
                                    color: Colors.greenAccent,
                                  ),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('students')
                                        .doc(student.id)
                                        .update({'isArchived': false});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
            Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Navbar(type: "archive")),
        ],
      ),
    );
  }
}
import 'dart:ui';
import 'package:attendance/view/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:attendance/component/navbar.dart';
import 'package:attendance/constants/attendance_colors.dart';
import 'package:attendance/view/student_detail_page.dart';
import 'package:attendance/view/student_edit.dart';

class HomePage extends StatefulWidget {
  @override   
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> attendanceMap = {};
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  Color? statusColor(String? status) => AttendanceColors.forStatus(status);

  Widget glassBox({required Widget child, Color? accent, bool birthday = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: birthday
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pinkAccent.withOpacity(0.22),
                      Colors.amber.withOpacity(0.18),
                      Colors.purpleAccent.withOpacity(0.18),
                    ],
                  )
                : null,
            color: birthday
                ? null
                :
            //  accent != null
            //     ? accent.withOpacity(0.12)
                 Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: birthday
                  ? Colors.amberAccent.withOpacity(0.8)
                  :
              //  accent != null
              //     ? accent.withOpacity(0.6)
                   Colors.white.withOpacity(0.12),
              width: birthday ? 1.6 : (accent != null ? 1.5 : 1),
            ),
            boxShadow: birthday
                ? [
                    BoxShadow(
                      color: Colors.amberAccent.withOpacity(0.10),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget statusChip(String text, Color color, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? color : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      /// 🌐 Glass AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: glassBox(
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (v) {
                        setState(() {
                          searchQuery = v.toLowerCase();
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Search student...",
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      String today =
                          DateTime.now().toIso8601String().split('T')[0];

                      await FirebaseFirestore.instance
                          .collection('attendance')
                          .doc(today)
                          .set(attendanceMap);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Attendance Submitted!")),
                      );
                    },
                    child: const Icon(Icons.done, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      /// 🌌 Body
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('students')
                .where('isArchived', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
          
              var students = snapshot.data!.docs.where((student) {
                String name = student['name'].toString().toLowerCase();
                return name.contains(searchQuery);
              }).toList();
          
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Total Students: ${students.length}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                       padding: const EdgeInsets.only(bottom: 90),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
                        String studentId = student.id;
                        String name = student['name'] ?? 'No Name';
                        Timestamp? ts = student['datetime'];
                        DateTime? date = ts?.toDate();
                        Map<String, dynamic> studentData =
                            student.data() as Map<String, dynamic>;
                        Timestamp? dobTs = studentData['DOB'];
                        DateTime? dob = dobTs?.toDate();
                        DateTime today = DateTime.now();
                        bool isBirthday = dob != null &&
                            dob.day == today.day &&
                            dob.month == today.month;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: glassBox(
                            birthday: isBirthday,
                            child: GestureDetector(
                              onLongPress: () {
                                 showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return Container(
                                      margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F172A),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.archive_outlined,
                                          color: Colors.redAccent,
                                        ),
                                        title: const Text(
                                          "Archive Student",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onTap: () async {
                                          await FirebaseFirestore.instance
                                              .collection('students')
                                              .doc(student.id)
                                              .update({'isArchived': true});
          
                                          Navigator.pop(context);
          
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Student Archived"),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => 
                                                StudentViewProfile(
                                                  studentId: student.id,
                                                  studentName: student['name'],
                                                  studendNumber: student['number'],
                                                  studendDate: student['datetime'],
                                                  studentDob: student['DOB'],
                                                  studendGender: student['gender'],
                                                )
                                                // StudentEdit(
                                                  // studentId: student.id,
                                                  // studentName: student['name'],
                                                  // studendNumber: student['number'],
                                                  // studendDate: student['datetime'],
                                                  // studentDob: student['DOB'],
                                                  // studendGender: student['gender'],
                                                // ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${index + 1}. ",
                                                    style: const TextStyle(
                                                      color: Colors.blueAccent,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                          if (isBirthday) ...[
                                                    const SizedBox(width: 6),
                                                    Icon(Icons.cake, color: Colors.blue,),
                                                    // const Text(
                                                    //   "🎂",
                                                    //   style: TextStyle(fontSize: 16),
                                                    // ),
                                                  ],
                                                      ],
                                                    ),
                                                  ),
                                                
                                                ],
                                              ),
                                              Text(
                                                date != null
                                                    ? "${date.day}-${date.month}-${date.year}"
                                                    : "No Date",
                                                style: const TextStyle(
                                                  color: Colors.white38,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white10,
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
                                      )
                                    ],
                                  ),
                              
                                  const SizedBox(height: 10),
                              
                                  /// Attendance Chips (modern radio replacement)
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      statusChip(
                                        "Present",
                                        AttendanceColors.present,
                                        attendanceMap[studentId] == "present",
                                        () {
                                          setState(() {
                                            attendanceMap[studentId] = "present";
                                          });
                                        },
                                      ),
                                      statusChip(
                                        "Absent",
                                        AttendanceColors.absent,
                                        attendanceMap[studentId] == "absent",
                                        () {
                                          setState(() {
                                            attendanceMap[studentId] = "absent";
                                          });
                                        },
                                      ),
                                      statusChip(
                                        "Leave",
                                        AttendanceColors.leave,
                                        attendanceMap[studentId] == "leave",
                                        () {
                                          setState(() {
                                            attendanceMap[studentId] = "leave";
                                          });
                                        },
                                      ),
                                      statusChip(
                                        "Holiday",
                                        AttendanceColors.holiday,
                                        attendanceMap[studentId] == "holiday",
                                        () {
                                          setState(() {
                                            attendanceMap[studentId] = "holiday";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                 
                                ],
                              ),
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
            child: Navbar(type: "Student")),
        ],
      ),
    );
  }
}



   // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 5),
              //       child: GestureDetector(
              //         onTap: () async {
              //           // String today = "2026-03-25";
              //           String today =
              //               DateTime.now().toIso8601String().split('T')[0];

              //           await FirebaseFirestore.instance
              //               .collection('attendance')
              //               .doc(today)
              //               .set(attendanceMap); // {studentId: status}

              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(content: Text("Attendance Submitted!")),
              //           );
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: Colors.blue,
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //               horizontal: 100,
              //               vertical: 20,
              //             ),
              //             child: Text(
              //               "Submit",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.only(right: 20),
              //     //   child: ElevatedButton(
              //     //     onPressed:
              //     //         () => Navigator.pushNamed(context, '/add_student'),
              //     //     child: Icon(Icons.person_add_alt_1, color: Colors.blue),
              //     //   ),
              //     // ),
              //   ],
              // ),

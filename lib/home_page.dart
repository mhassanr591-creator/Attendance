import 'package:attendance/student_detail_page.dart';
import 'package:attendance/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> attendanceMap = {};
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  final FocusNode searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search student...",
                // prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/add_student'),
              child: Icon(Icons.person_add_alt_1, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          // var students = snapshot.data!.docs;
          var students =
              snapshot.data!.docs.where((student) {
                String name = student['name'].toString().toLowerCase();
                return name.contains(searchQuery);
              }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Total Students: ${students.length}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    String studentId = student.id;
                    String studentName = student['name'] ?? 'No Name';
                    Timestamp? timestamp = student['datetime'];
                    DateTime? joiningdate = timestamp?.toDate();
                    // String studentimg =
                    //     student['image'] ??
                    //     'https://www.savethechildren.org/us/what-we-do/education/literacy-in-us';
                    // String studentnumber = student['number'] ?? 'No Name';

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {},
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // GestureDetector(
                                // onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder:
                                //           (_) => StudentProfile(
                                //             studentId: student.id,
                                //             studentName: student['name'],
                                //             studendNumber: student['number'],
                                //             studentImage: student['image'],
                                //           ),
                                //     ),
                                //   );
                                // },
                                //   child: CircleAvatar(
                                //     radius: 25,
                                //     backgroundImage: NetworkImage(studentimg),
                                //   ),
                                // ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => StudentProfile(
                                              studentId: student.id,
                                              studentName: student['name'],
                                              studendNumber: student['number'],
                                              studendDate: student['datetime'],
                                              studendGender: student['gender'],
                                              // studentImage: student['image'],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${index + 1}.", // ⭐ SERIAL NUMBER
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            studentName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        joiningdate != null
                                            ? "${joiningdate.day}-${joiningdate.month}-${joiningdate.year}"
                                            : "No Date",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // IconButton(
                            //   icon: Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     _confirmDelete(studentId, context);
                            //   },
                            // ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => StudentDetailPage(
                                          studentId: student.id,
                                          studentName: student['name'],
                                          studendNumber: student['number'],
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Overview",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Radio<String>(
                              activeColor: Colors.green,
                              value: 'present',
                              groupValue: attendanceMap[studentId],
                              onChanged: (val) {
                                setState(() {
                                  attendanceMap[studentId] = val!;
                                });
                              },
                            ),
                            Text('Present'),
                            Radio<String>(
                              activeColor: Colors.yellow,
                              value: 'leave',
                              groupValue: attendanceMap[studentId],
                              onChanged: (val) {
                                setState(() {
                                  attendanceMap[studentId] = val!;
                                });
                              },
                            ),
                            Text('Leave'),
                            Radio<String>(
                              activeColor: Colors.red,
                              value: 'absent',
                              groupValue: attendanceMap[studentId],
                              onChanged: (val) {
                                setState(() {
                                  attendanceMap[studentId] = val!;
                                });
                              },
                            ),
                            Text('Absent'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                      onTap: () async {
                        // String today = "2026-03-25";
                        String today =
                            DateTime.now().toIso8601String().split('T')[0];

                        await FirebaseFirestore.instance
                            .collection('attendance')
                            .doc(today)
                            .set(attendanceMap); // {studentId: status}

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Attendance Submitted!")),
                        );
                      },
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
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 20),
                  //   child: ElevatedButton(
                  //     onPressed:
                  //         () => Navigator.pushNamed(context, '/add_student'),
                  //     child: Icon(Icons.person_add_alt_1, color: Colors.blue),
                  //   ),
                  // ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// void _confirmDelete(String studentId, context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text("Delete Student"),
//         content: Text("Are you sure you want to delete this student?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await _deleteStudent(studentId, context);
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<void> _deleteStudent(String studentId, context) async {
//   await FirebaseFirestore.instance
//       .collection('students')
//       .doc(studentId)
//       .delete();

//   ScaffoldMessenger.of(
//     context,
//   ).showSnackBar(SnackBar(content: Text("Student deleted")));
// }

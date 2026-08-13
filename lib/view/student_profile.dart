import 'package:attendance/view/student_edit.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentViewProfile extends StatelessWidget {
  final String studentId;
  final String studentName;
  final String studendNumber;
  final Timestamp studendDate;
  final Timestamp studentDob;
  final String studendGender;

  const StudentViewProfile({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.studendNumber,
    required this.studendDate,
    required this.studentDob,
    required this.studendGender,
  });

  Widget infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(Timestamp ts) {
    final d = ts.toDate();
    return "${d.day}-${d.month}-${d.year}";
  }

  int calculateAge(Timestamp dob) {
    final birth = dob.toDate();
    final today = DateTime.now();
    int age = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Student Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "$studentName (${calculateAge(studentDob)} yrs)",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active Student",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Details
            infoTile(
              icon: Icons.phone,
              title: "Phone Number",
              value: studendNumber,
            ),

            infoTile(
              icon: Icons.person_outline,
              title: "Gender",
              value: studendGender,
            ),

            infoTile(
              icon: Icons.cake_outlined,
              title: "Date of Birth",
              value: formatDate(studentDob),
            ),

            infoTile(
              icon: Icons.calendar_month,
              title: "Joining Date",
              value: formatDate(studendDate),
            ),
            const SizedBox(height: 30),
            /// Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => StudentEdit(
                            studentId: studentId,
                            studentName: studentName,
                            studendNumber: studendNumber,
                            studendDate: studendDate,
                            studentDob: studentDob,
                            studendGender: studendGender,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:attendance/view/student_edit.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class StudentViewProfile extends StatelessWidget {
//   final String studentId;
//   final String studentName;
//   final String studendNumber;
//   final Timestamp studendDate;
//   final Timestamp studentDob;
//   final String studendGender;

//   const StudentViewProfile({
//     super.key,
//     required this.studentId,
//     required this.studentName,
//     required this.studendNumber,
//     required this.studendDate,
//     required this.studentDob,
//     required this.studendGender,
//   });

//   String formatDate(Timestamp ts) {
//     final d = ts.toDate();
//     return "${d.day}-${d.month}-${d.year}";
//   }

//   Widget infoCard({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: const Color(0xFF111827),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 48,
//             width: 48,
//             decoration: BoxDecoration(
//               color: Colors.blueAccent.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Icon(icon, color: Colors.blueAccent),
//           ),
//           const SizedBox(width: 14),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white54,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF070B1A),

//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             /// TOP HERO SECTION
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   height: 100,
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF2563EB),
//                         Color(0xFF1E40AF),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(35),
//                       bottomRight: Radius.circular(35),
//                     ),
//                   ),
//                 ),

//                 SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: const Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const Spacer(),
//                         // const Text(
//                         //   "Student Profile",
//                         //   style: TextStyle(
//                         //     color: Colors.white,
//                         //     fontSize: 18,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         // ),
//                         // // const Spacer(),
//                         // const SizedBox(width: 40),
//                       ],
//                     ),
//                   ),
//                 ),

//                 /// FLOATING AVATAR
//                 Positioned(
//                   bottom: -55,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Container(
//                       padding: const EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF070B1A),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const CircleAvatar(
//                         radius: 55,
//                         backgroundColor: Colors.white,
//                         child: Icon(
//                           Icons.person,
//                           size: 55,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 70),

//             /// NAME
//             Text(
//               studentName,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 8),

//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 6,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 "Active Student",
//                 style: TextStyle(
//                   color: Colors.greenAccent,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// DETAILS SECTION
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Personal Information",
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   infoCard(
//                     icon: Icons.phone,
//                     title: "Phone Number",
//                     value: studendNumber,
//                   ),

//                   infoCard(
//                     icon: Icons.person_outline,
//                     title: "Gender",
//                     value: studendGender,
//                   ),

//                   infoCard(
//                     icon: Icons.cake,
//                     title: "Date of Birth",
//                     value: formatDate(studentDob),
//                   ),

//                   infoCard(
//                     icon: Icons.calendar_month,
//                     title: "Joining Date",
//                     value: formatDate(studendDate),
//                   ),

//                   const SizedBox(height: 30),

//                   /// EDIT BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     height: 58,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => StudentEdit(
//                               studentId: studentId,
//                               studentName: studentName,
//                               studendNumber: studendNumber,
//                               studendDate: studendDate,
//                               studentDob: studentDob,
//                               studendGender: studendGender,
//                             ),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                       ),
//                       child: const Text(
//                         "Edit Profile",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
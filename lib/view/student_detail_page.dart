// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:table_calendar/table_calendar.dart';

// class StudentDetailPage extends StatefulWidget {
//   final String studentId;
//   final String studentName;
//   final String studendNumber;

//   const StudentDetailPage({
//     required this.studentId,
//     required this.studentName,
//     required this.studendNumber,
//   });
//   @override
//   State<StudentDetailPage> createState() => _StudentDetailPageState();
// }

// class _StudentDetailPageState extends State<StudentDetailPage> {
//   Map<DateTime, String> _attendance = {};
//   DateTime _focusedDay = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _loadAttendance();
//   }

//   // ✅ FIX 1: Normalize date (IMPORTANT)
//   DateTime _normalize(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//     // return DateTime(date.year, date.month, date.day);
//   }

//   // ✅ FIX 2: Load data properly
//   void _loadAttendance() async {
//     final snapshot =
//         await FirebaseFirestore.instance.collection('attendance').get();

//     Map<DateTime, String> data = {};

//     for (var doc in snapshot.docs) {
//       final date = _normalize(DateTime.parse(doc.id));

//       if (doc.data().containsKey(widget.studentId)) {
//         data[date] = doc[widget.studentId];
//       }
//     }

//     setState(() {
//       _attendance = data;
//     });
//   }

//   // ✅ FIX 3: Case handling
//   Color _getColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'present':
//         return const Color(0xFF00910C);
//       case 'absent':
//         return const Color(0xFFFF1100);
//       case 'leave':
//         return const Color(0xFFFF9900);
//       default:
//         return Colors.grey;
//     }
//   }

//   // bool _isSameDay(DateTime a, DateTime b) {
//   //   return a.year == b.year && a.month == b.month && a.day == b.day;
//   // }

//   Map<String, int> _getMonthlyTotals() {
//     int present = 0;
//     int absent = 0;
//     int leave = 0;

//     _attendance.forEach((date, status) {
//       if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
//         if (status.toLowerCase() == 'present') {
//           present++;
//         } else if (status.toLowerCase() == 'absent') {
//           absent++;
//         } else if (status.toLowerCase() == 'leave') {
//           leave++;
//         }
//       }
//     });

//     return {'present': present, 'absent': absent, 'leave': leave};
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totals = _getMonthlyTotals();
//     int totalDays = (totals['present']! + totals['leave']! + totals['absent']!);

//     double presentPercent = totalDays == 0 ? 0 : totals['present']! / totalDays;

//     double leavePercent = totalDays == 0 ? 0 : totals['leave']! / totalDays;

//     double absentPercent = totalDays == 0 ? 0 : totals['absent']! / totalDays;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.blue,
//         title: Text(
//           "${widget.studentName} Overview",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TableCalendar(
//               firstDay: DateTime.utc(2023, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
        
//               onPageChanged: (focusedDay) {
//                 setState(() {
//                   _focusedDay = focusedDay; // 👈 month change track hoga
//                 });
//               },
        
//               // 🔥 IMPORTANT: this improves matching
//               calendarBuilders: CalendarBuilders(
//                 defaultBuilder: (context, day, focusedDay) {
//                   final normalizedDay = _normalize(day);
        
//                   if (_attendance.containsKey(normalizedDay)) {
//                     final status = _attendance[normalizedDay]!;
        
//                     return Container(
//                       margin: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: _getColor(status),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         '${day.day}',
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     );
//                   }
        
//                   return null;
//                 },
//               ),
//             ),
//             SizedBox(height: 50),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.blue,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.location_history_rounded, color: Colors.white,),
//                       SizedBox(width: 5,),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Attendance Graph",
//                           // "${widget.studendNumber ?? "N/A"}",
//                           style: TextStyle(fontSize: 18, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Text(
//                   "${_focusedDay.month}/${_focusedDay.year} Summary",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
        
//                 SizedBox(height: 10),
        
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Present (${totals['present']})",
//                         style: TextStyle(fontSize: 16),
//                       ),
        
//                       SizedBox(height: 5),
        
//                       LinearProgressIndicator(
//                         borderRadius: BorderRadius.circular(20),
//                         value: presentPercent,
//                         minHeight: 10,
//                         backgroundColor: Colors.grey[300],
//                         valueColor: AlwaysStoppedAnimation(Color(0xFF00910C)),
//                       ),
//                       SizedBox(height: 15),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Leave (${totals['leave']})",
//                         style: TextStyle(fontSize: 16),
//                       ),
        
//                       SizedBox(height: 5),
        
//                       LinearProgressIndicator(
//                         borderRadius: BorderRadius.circular(20),
//                         value: leavePercent,
//                         minHeight: 10,
//                         backgroundColor: Colors.grey[300],
//                         valueColor: AlwaysStoppedAnimation(Color(0xFFFF9900)),
//                       ),
        
//                       SizedBox(height: 15),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Absent (${totals['absent']})",
//                         style: TextStyle(fontSize: 16),
//                       ),
        
//                       SizedBox(height: 5),
        
//                       LinearProgressIndicator(
//                         borderRadius: BorderRadius.circular(20),
//                         value: absentPercent,
//                         minHeight: 10,
//                         backgroundColor: Colors.grey[300],
//                         valueColor: AlwaysStoppedAnimation(Color(0xFFFF1100)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Container(
//             //       decoration: BoxDecoration(
//             //         color: Color(0xFF00910C),
//             //         borderRadius: BorderRadius.circular(10),
//             //       ),
//             //       height: 45,
//             //       width: 45,
//             //     ),
//             //     SizedBox(width: 5),
//             //     Text("Present", style: TextStyle(fontSize: 20)),
//             //   ],
//             // ),
//             // SizedBox(height: 5),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Container(
//             //       decoration: BoxDecoration(
//             //         color: Color(0xFFFF9900),
//             //         borderRadius: BorderRadius.circular(10),
//             //       ),
//             //       height: 45,
//             //       width: 45,
//             //     ),
//             //     SizedBox(width: 5),
//             //     Text("Leave   ", style: TextStyle(fontSize: 20)),
//             //   ],
//             // ),
//             // SizedBox(height: 5),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   children: [
//             //     Container(
//             //       decoration: BoxDecoration(
//             //         color: Color(0xFFFF1100),
//             //         borderRadius: BorderRadius.circular(10),
//             //       ),
//             //       height: 45,
//             //       width: 45,
//             //     ),
//             //     SizedBox(width: 5),
//             //     Text("Absent", style: TextStyle(fontSize: 20)),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:attendance/constants/attendance_colors.dart';

class StudentDetailPage extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studendNumber;

  const StudentDetailPage({
    required this.studentId,
    required this.studentName,
    required this.studendNumber,
  });

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  Map<DateTime, String> _attendance = {};
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  void _loadAttendance() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('attendance').get();

    Map<DateTime, String> data = {};

    for (var doc in snapshot.docs) {
      final date = _normalize(DateTime.parse(doc.id));

      if (doc.data().containsKey(widget.studentId)) {
        data[date] = doc[widget.studentId];
      }
    }

    setState(() => _attendance = data);
  }

  Color _statusColor(String status) {
    return AttendanceColors.forStatus(status) ?? Colors.white24;
  }

  Map<String, int> _monthlyTotals() {
    int p = 0, a = 0, l = 0, h = 0;

    _attendance.forEach((date, status) {
      if (date.year == _focusedDay.year &&
          date.month == _focusedDay.month) {
        if (status == 'present') p++;
        if (status == 'absent') a++;
        if (status == 'leave') l++;
        if (status == 'holiday') h++;
      }
    });

    return {'present': p, 'absent': a, 'leave': l, 'holiday': h};
  }

  Widget card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _monthlyTotals();
    int total = m['present']! + m['absent']! + m['leave']! + m['holiday']!;

    double p = total == 0 ? 0 : m['present']! / total;
    double a = total == 0 ? 0 : m['absent']! / total;
    double l = total == 0 ? 0 : m['leave']! / total;
    double h = total == 0 ? 0 : m['holiday']! / total;

    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.studentName,
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              /// 🔵 TOP STATS
              Row(
                children: [
                  Expanded(child: _stat("Present", m['present']!, AttendanceColors.present)),
                  const SizedBox(width: 8),
                  Expanded(child: _stat("Leave", m['leave']!, AttendanceColors.leave)),
                  const SizedBox(width: 8),
                  Expanded(child: _stat("Absent", m['absent']!, AttendanceColors.absent)),
                  const SizedBox(width: 8),
                  Expanded(child: _stat("Holiday", m['holiday']!, AttendanceColors.holiday)),
                ],
              ),

              const SizedBox(height: 12),

              /// 📅 CALENDAR (FIXED HEADER + ARROWS)
              card(
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2023),
                  lastDay: DateTime.utc(2030),

                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white70),
                    weekendStyle: TextStyle(color: Colors.white70),
                  ),

                  calendarStyle: const CalendarStyle(
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle: TextStyle(color: Colors.white38),
                  ),

                  onPageChanged: (d) {
                    setState(() => _focusedDay = d);
                  },

                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final d = _normalize(day);

                      if (_attendance.containsKey(d)) {
                        return Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _statusColor(_attendance[d]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                    todayBuilder: (context, day, _) {
                      final d = _normalize(day);

                      if (_attendance.containsKey(d)) {
                        return Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _statusColor(_attendance[d]!),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purpleAccent),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            "${day.day}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// 📊 PROGRESS SECTION
              card(
                child: Column(
                  children: [
                    _bar("Present", p, AttendanceColors.present),
                    const SizedBox(height: 10),
                    _bar("Leave", l, AttendanceColors.leave),
                    const SizedBox(height: 10),
                    _bar("Absent", a, AttendanceColors.absent),
                    const SizedBox(height: 10),
                    _bar("Holiday", h, AttendanceColors.holiday),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔵 STAT CARD
  Widget _stat(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            "$value",
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 PROGRESS BAR
  Widget _bar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation(color),
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
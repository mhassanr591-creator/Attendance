import 'package:attendance/component/navbar.dart';
import 'package:attendance/constants/attendance_colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int present = 0;
  int absent = 0;
  int leave = 0;
  int holiday = 0;

  bool loading = true;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);

    final snapshot =
        await FirebaseFirestore.instance.collection('attendance').get();

    int p = 0, a = 0, l = 0, h = 0;

    for (var doc in snapshot.docs) {
      DateTime date = DateTime.parse(doc.id);

      if (date.month == selectedMonth && date.year == selectedYear) {
        final data = doc.data();

        data.forEach((key, value) {
          String status = value.toString().toLowerCase();

          if (status == "present") {
            p++;
          } else if (status == "absent") {
            // ignore: curly_braces_in_flow_control_structures
            a++;
          } else if (status == "leave") {
            // ignore: curly_braces_in_flow_control_structures
            l++;
          } else if (status == "holiday") {
            // ignore: curly_braces_in_flow_control_structures
            h++;
          }
        });
      }
    }

    setState(() {
      present = p;
      absent = a;
      leave = l;
      holiday = h;
      loading = false;
    });
  }

  void openPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Month",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  const SizedBox(height: 15),

                  /// MONTHS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      return ChoiceChip(
                        label: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.black),
                        ),
                        selected: selectedMonth == index + 1,
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white10,
                        onSelected: (val) {
                          setModalState(() {
                            selectedMonth = index + 1;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Select Year",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),

                  /// YEARS
                  Wrap(
                    spacing: 8,
                    children: List.generate(5, (i) {
                      int year = DateTime.now().year - i;

                      return ChoiceChip(
                        label: Text(
                          "$year",
                          style: const TextStyle(color: Colors.black),
                        ),
                        selected: selectedYear == year,
                        selectedColor: Colors.green,
                        backgroundColor: Colors.white10,
                        onSelected: (val) {
                          setModalState(() {
                            selectedYear = year;
                          });
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      fetchData();
                    },
                    child: Row(children: [const Text("Apply")]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<ChartData> get chartData => [
    ChartData("Present", present, AttendanceColors.present),
    ChartData("Absent", absent, AttendanceColors.absent),
    ChartData("Leave", leave, AttendanceColors.leave),
    ChartData("Holiday", holiday, AttendanceColors.holiday),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B1A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// PICKER BUTTON
                    GestureDetector(
                      onTap: openPicker,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$selectedMonth / $selectedYear",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        statCard("Present", present, AttendanceColors.present),
                        statCard("Absent", absent, AttendanceColors.absent),
                        statCard("Leave", leave, AttendanceColors.leave),
                        statCard("Holiday", holiday, AttendanceColors.holiday),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          textStyle: const TextStyle(color: Colors.white70),
                        ),
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (d, _) => d.status,
                            yValueMapper: (d, _) => d.value,
                            pointColorMapper: (d, _) => d.color,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Navbar(type: "DashBoard"),
          ),
        ],
      ),
    );
  }

  Widget statCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              "$value",
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String status;
  final int value;
  final Color color;

  ChartData(this.status, this.value, this.color);
}

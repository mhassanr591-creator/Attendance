// import 'package:attendance/view/add_student_page.dart';
// import 'package:attendance/view/archive.dart';
// import 'package:attendance/view/dashboard.dart';
// import 'package:attendance/view/home_page.dart';
// import 'package:flutter/material.dart';

// class Navbar extends StatefulWidget {
//   final String type;
//   const Navbar({super.key, required this.type});

//   @override
//   State<Navbar> createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
//       // width: MediaQuery.of(context).size.width,
//       // height: kBottomNavigationBarHeight,
//       height: 60.0,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Bottombuttons(
//                   iconcolor:
//                       widget.type == 'DashBoard' ? Colors.white : Colors.black,
//                   icon: Icons.home_filled,
//                   bcolor:
//                       widget.type == 'DashBoard'
//                           ? Colors.blueGrey
//                           : Colors.white,
//                   onpress: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Dashboard()),
//                     );
//                   },
//                 ),
//                 Bottombuttons(
//                   iconcolor:
//                       widget.type == 'Student' ? Colors.white : Colors.black,
//                   icon: Icons.people_alt_sharp,
//                   bcolor:
//                       widget.type == 'Student' ? Colors.blueGrey : Colors.white,
//                   onpress: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                     );
//                   },
//                 ),
//                 Bottombuttons(
//                   iconcolor:
//                       widget.type == 'archive' ? Colors.white : Colors.black,
//                   icon: Icons.archive_outlined,
//                   bcolor:
//                       widget.type == 'archive' ? Colors.blueGrey : Colors.white,
//                   onpress: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ArchiveScreen()),
//                     );
//                   },
//                 ),
//                 Bottombuttons(
//                   iconcolor: widget.type == 'Add' ? Colors.white : Colors.black,
//                   icon: Icons.person_add_alt_1,
//                   bcolor: widget.type == 'Add' ? Colors.blueGrey : Colors.white,
//                   onpress: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => AddStudentPage()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Bottombuttons extends StatefulWidget {
//   final icon;
//   void Function()? onpress;
//   Color bcolor;
//   Color iconcolor;

//   Bottombuttons({
//     super.key,
//     required this.icon,
//     this.onpress,
//     required this.bcolor,
//     required this.iconcolor,
//   });

//   @override
//   State<Bottombuttons> createState() => _BottombuttonsState();
// }

// class _BottombuttonsState extends State<Bottombuttons> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.onpress,
//       child: Container(
//         height: 50,
//         width: 50,
//         decoration: BoxDecoration(
//           color: widget.bcolor,
//           borderRadius: BorderRadius.circular(50),
//           // border: Border.all(color: Colors.blueGrey),
//         ),
//         child: Icon(widget.icon, color: widget.iconcolor, size: 20),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:attendance/view/add_student_page.dart';
import 'package:attendance/view/archive.dart';
import 'package:attendance/view/dashboard.dart';
import 'package:attendance/view/home_page.dart';

class Navbar extends StatelessWidget {
  final String type;
  const Navbar({super.key, required this.type});

  void go(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget item({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active
              ? Colors.blueAccent.withOpacity(0.20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          size: active ? 28 : 24,
          color: active ? Colors.blueAccent : Colors.white70,
        ),
      ),
    );
  }

  Widget glassBar(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: glassBar(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                item(
                  icon: Icons.home_filled,
                  active: type == 'DashBoard',
                  onTap: () => go(context, Dashboard()),
                ),
                const SizedBox(width: 14),

                item(
                  icon: Icons.people_alt,
                  active: type == 'Student',
                  onTap: () => go(context, HomePage()),
                ),
                const SizedBox(width: 14),

                item(
                  icon: Icons.archive_outlined,
                  active: type == 'archive',
                  onTap: () => go(context, ArchiveScreen()),
                ),
                const SizedBox(width: 14),

                item(
                  icon: Icons.person_add_alt_1,
                  active: type == 'Add',
                  onTap: () => go(context, AddStudentPage()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:attendance/view/dashboard.dart';
// import 'package:attendance/view/home_page.dart';
// import 'package:flutter/material.dart';

// class Navbar extends StatefulWidget {
//   final String type;
//   const Navbar({super.key, required this.type});

//   @override
//   State<Navbar> createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           color: Colors.white.withOpacity(0.5),
//         ),
//         // width: MediaQuery.of(context).size.width,
//         // height: kBottomNavigationBarHeight,
//         height: 70.0,
//         child: Scaffold(
//           // white: Colors.transparent,
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Bottombuttons(
//                       iconcolor:
//                           widget.type == 'DashBoard'
//                               ? Colors.white
//                               : Colors.black,
//                       icon: Icons.home_filled,
//                       bcolor:
//                           widget.type == 'DashBoard'
//                               ? Colors.blueGrey
//                               : Colors.white,
//                       onpress: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => Dashboard()),
//                         );
//                       },
//                     ),
//                     Bottombuttons(
//                       iconcolor:
//                           widget.type == 'Add' ? Colors.white : Colors.black,
//                       icon: Icons.people_alt_sharp,
//                       bcolor:
//                           widget.type == 'Add' ? Colors.blueGrey : Colors.white,
//                       onpress: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomePage()),
//                         );
//                       },
//                     ),
//                     Bottombuttons(
//                       iconcolor:
//                           widget.type == 'P_Profile'
//                               ? Colors.white
//                               : Colors.black,
//                       icon: Icons.person,
//                       bcolor:
//                           widget.type == 'P_Profile'
//                               ? Colors.blueGrey
//                               : Colors.white,
//                       onpress: () {
//                         // Get.offNamed(RoutesName.principalProfile);
//                       },
//                     ),
//                     Bottombuttons(
//                       iconcolor:
//                           widget.type == 'P_MTS' ? Colors.white : Colors.black,
//                       icon: Icons.menu_book_rounded,
//                       bcolor:
//                           widget.type == 'P_MTS'
//                               ? Colors.blueGrey
//                               : Colors.white,
//                       onpress: () {
//                         // Get.offNamed(RoutesName.principalManageTS);
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Bottombuttons extends StatefulWidget {
//   final icon;
//   void Function()? onpress;
//   Color bcolor;
//   Color iconcolor;

//   Bottombuttons({
//     super.key,
//     required this.icon,
//     this.onpress,
//     required this.bcolor,
//     required this.iconcolor,
//   });

//   @override
//   State<Bottombuttons> createState() => _BottombuttonsState();
// }

// class _BottombuttonsState extends State<Bottombuttons> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.onpress,
//       child: Container(
//         height: 50,
//         width: 50,
//         decoration: BoxDecoration(
//           color: widget.bcolor,
//           borderRadius: BorderRadius.circular(50),
//           // border: Border.all(color: Colors.blueGrey),
//         ),
//         child: Icon(widget.icon, color: widget.iconcolor),
//       ),
//     );
//   }
// }

import 'package:attendance/view/add_student_page.dart';
import 'package:attendance/view/archive.dart';
import 'package:attendance/view/dashboard.dart';
import 'package:attendance/view/home_page.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final String type;
  const Navbar({super.key, required this.type});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      // width: MediaQuery.of(context).size.width,
      // height: kBottomNavigationBarHeight,
      height: 60.0,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Bottombuttons(
                  iconcolor:
                      widget.type == 'DashBoard' ? Colors.white : Colors.black,
                  icon: Icons.home_filled,
                  bcolor:
                      widget.type == 'DashBoard'
                          ? Colors.blueGrey
                          : Colors.white,
                  onpress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                ),
                Bottombuttons(
                  iconcolor: widget.type == 'Student' ? Colors.white : Colors.black,
                  icon: Icons.people_alt_sharp,
                  bcolor: widget.type == 'Student' ? Colors.blueGrey : Colors.white,
                  onpress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                Bottombuttons(
                  iconcolor:
                      widget.type == 'archive' ? Colors.white : Colors.black,
                  icon: Icons.archive_outlined,
                  bcolor:
                      widget.type == 'archive'
                          ? Colors.blueGrey
                          : Colors.white,
                  onpress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArchiveScreen()),
                    );
                  },
                ),
                Bottombuttons(
                  iconcolor:
                      widget.type == 'Add' ? Colors.white : Colors.black,
                  icon: Icons.person_add_alt_1,
                  bcolor:
                      widget.type == 'Add' ? Colors.blueGrey : Colors.white,
                  onpress: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddStudentPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Bottombuttons extends StatefulWidget {
  final icon;
  void Function()? onpress;
  Color bcolor;
  Color iconcolor;

  Bottombuttons({
    super.key,
    required this.icon,
    this.onpress,
    required this.bcolor,
    required this.iconcolor,
  });

  @override
  State<Bottombuttons> createState() => _BottombuttonsState();
}

class _BottombuttonsState extends State<Bottombuttons> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onpress,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: widget.bcolor,
          borderRadius: BorderRadius.circular(50),
          // border: Border.all(color: Colors.blueGrey),
        ),
        child: Icon(widget.icon, color: widget.iconcolor, size: 20),
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

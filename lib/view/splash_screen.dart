// import 'package:attendance/view/dashboard.dart';
// import 'package:attendance/view/home_page.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     // 🔥 Animation Controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     )..repeat(reverse: true);

//     // 🔥 Up-Down Animation
//     _animation = Tween<double>(
//       begin: -20,
//       end: 20,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     // 🔥 3 sec delay → Navigate
//     Timer(Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Dashboard()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       // backgroundColor: const Color(0xFF414447),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(),
//           Center(
//             child: AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Transform.translate(
//                   offset: Offset(0, _animation.value),
//                   child: child,
//                 );
//               },
//               child: CircleAvatar(
//                 radius: 100,
//                 backgroundImage: AssetImage('assets/images/hassan_Profile.png'),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 50),
//             child: Column(
//               children: [
//                 Text(
//                   "Hassan Academy",
//                   style: TextStyle(
//                     fontSize: 40,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 100),
//                     child: LinearProgressIndicator(
//                           borderRadius: BorderRadius.circular(20),
//                           // value: 0.5,
//                           minHeight: 2,
//                           backgroundColor: Colors.grey[300],
//                           valueColor: AlwaysStoppedAnimation(Color(0xFF414447)),
//                         ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:ui';
import 'package:attendance/view/dashboard.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Timer(const Duration(seconds: 3), () {
         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget softOrb({
    required double size,
    required Color color,
    required double x,
    required double y,
  }) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.25),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 1,
            ),
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
      body: Stack(
        children: [
          /// Subtle Spatial Depth Layers
          softOrb(size: 180, color: Colors.blue, x: 40, y: 100),
          softOrb(size: 140, color: Colors.purple, x: 220, y: 220),
          softOrb(size: 200, color: Colors.cyan, x: 80, y: 500),

          /// Main Center Content
          Center(
            child: AnimatedBuilder(
              animation: _floatAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child,
                );
              },
              child: glassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Profile Image (clean spatial focus)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: const AssetImage(
                          'assets/images/hassan_Profile.png',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// Title
                    const Text(
                      "Hassan Academy",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// Progress (minimal professional)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 5,
                        width: 180,
                        color: Colors.white10,
                        child: const LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                            Color(0xFF6EE7FF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
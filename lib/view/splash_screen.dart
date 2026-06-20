import 'package:attendance/view/dashboard.dart';
import 'package:attendance/view/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 🔥 Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // 🔥 Up-Down Animation
    _animation = Tween<double>(
      begin: -20,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 🔥 3 sec delay → Navigate
    Timer(Duration(seconds: 3), () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      // backgroundColor: const Color(0xFF414447),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                );
              },
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/hassan_Profile.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                Text(
                  "Hassan Academy",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(20),
                          // value: 0.5,
                          minHeight: 2,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(Color(0xFF414447)),
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

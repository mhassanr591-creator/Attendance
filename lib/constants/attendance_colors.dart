import 'package:flutter/material.dart';

class AttendanceColors {
  static const Color present = Colors.green;
  static const Color absent = Colors.red;
  static const Color leave = Colors.orange;
  static const Color holiday = Color(0xFF5694FF);

  static Color? forStatus(String? status) {
    switch (status?.toLowerCase()) {
      case "present":
        return present;
      case "absent":
        return absent;
      case "leave":
        return leave;
      case "holiday":
        return holiday;
      default:
        return null;
    }
  }
}

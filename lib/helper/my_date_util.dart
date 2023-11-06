import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtil {
  //getting formatted time for millisecond
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final timeFormat = DateFormat.jm(); // 'h:mm a' format for AM/PM
    return timeFormat.format(date);
  }
}

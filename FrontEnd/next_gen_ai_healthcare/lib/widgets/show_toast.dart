import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastMessage(String message) {
  try {
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: const Color(0xFFFF9800).withOpacity(0.3),
        gravity: ToastGravity.BOTTOM,
      );
    }
  } catch (e) {
    debugPrint("Flutter Toast is not compatible with web");
    // You can use an alternative approach for web, such as showing a SnackBar or an AlertDialog
    // For example, you can use the following code to show a SnackBar:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),
    // );
  }
}

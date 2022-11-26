import 'dart:developer';

import 'package:flutter/foundation.dart';

class Log {
  static void d(dynamic message) {
    if (kDebugMode) {
      print('d: $message');
    }
  }

  static void e(dynamic message) {
    if (kDebugMode) {
      print('e: $message');
    }
  }

  static void w(dynamic message) {
    if (kDebugMode) {
      print('w: $message');
    }
  }

  static void i(dynamic message) {
    if (kDebugMode) {
      print('i: $message');
    }
  }
}

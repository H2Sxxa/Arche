// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/foundation.dart';

void debugWrite(message) {
  if (kDebugMode) {
    window.console.log(message.toString());
  }
}

void debugWriteln(message) {
  debugWrite("$message\n");
}

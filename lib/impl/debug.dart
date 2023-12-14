import 'dart:io';

import 'package:flutter/foundation.dart';

void debugPrintln(message) {
  if (kDebugMode) {
    debugPrint("$message\n");
  }
}

void debugPrint(message) {
  if (kDebugMode) {
    stdout.write(message.toString());
  }
}

T? debugExecute<T>(T Function() F) {
  if (kDebugMode) {
    return F();
  }
  return null;
}

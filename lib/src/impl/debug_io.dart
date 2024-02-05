import 'package:flutter/foundation.dart';

import 'dart:io';

void debugWrite([message = ""]) {
  if (kDebugMode) {
    stdout.write(message.toString());
  }
}

void debugWriteln([message = ""]) {
  debugWrite("$message\n");
}

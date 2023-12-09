import 'package:flutter/foundation.dart';

void debugPrintln(message) {
  if (kDebugMode) {
    print(message);
  }
}

T? debugExecute<T>(T Function() F) {
  if (kDebugMode) {
    return F();
  }
  return null;
}

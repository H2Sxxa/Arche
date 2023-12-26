import 'package:flutter/foundation.dart';

T? debugExecute<T>(T Function() F) {
  if (kDebugMode) {
    return F();
  }
  return null;
}

import 'package:flutter/foundation.dart';
export 'package:arche/src/impl/debug_io.dart'
    if (dart.library.html) 'package:arche/src/impl/debug_web.dart'
    show debugWrite, debugWriteln;

T? debugExecute<T>(T Function() F) {
  if (kDebugMode) {
    return F();
  }
  return null;
}

T dbg<T>(T data) {
  debugPrint(data.toString());
  return data;
}

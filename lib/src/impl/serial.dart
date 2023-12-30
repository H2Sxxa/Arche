import 'dart:convert';

import 'package:arche/src/abc/serial.dart';

class JsonSerializer<K, V> implements MapSerializer<K, V, String> {
  @override
  Map<K, V> decode(String data) {
    return jsonDecode(data);
  }

  @override
  String encode(Map object) {
    return jsonEncode(object);
  }
}

import 'dart:io';

import 'package:arche/arche.dart';
import 'package:flutter/services.dart';

class ArcheConfig<K, V> extends Subordinate with KVIO<K, V> {
  @override
  TypeProvider get provider => singleton.provideof(instance: ArcheBus());

  late MapSerializer<K, V, String> serializer = JsonSerializer();
  bool _memory = false;
  final Map<K, V> _memorymap = {};
  String _path = "";

  ArcheConfig.memory(
      {String init = "{}", MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    _memorymap.addAll(this.serializer.decode(init));
  }

  ArcheConfig.asset(String name, {MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    rootBundle
        .loadString(name)
        .then((value) => _memorymap.addAll(this.serializer.decode(value)));
  }

  ArcheConfig.path(this._path, {MapSerializer<K, V, String>? serializer}) {
    if (serializer != null) {
      this.serializer = serializer;
    }

    if (!File(_path).existsSync()) {
      File(_path).writeAsStringSync("{}");
    }
  }

  ArcheConfig.file(File file, {MapSerializer<K, V, String>? serializer}) {
    if (serializer != null) {
      this.serializer = serializer;
    }

    _path = file.absolute.path;

    if (!file.existsSync()) {
      file.writeAsStringSync("{}");
    }
  }

  @override
  Map<K, V> read() {
    if (_memory) {
      return _memorymap;
    } else {
      return serializer.decode(File(_path).readAsStringSync());
    }
  }

  @override
  void write(K key, V value) {
    if (_memory) {
      _memorymap[key] = value;
    } else {
      var f = File(_path);
      var m = serializer.decode(f.readAsStringSync());
      m[key] = value;
      f.writeAsString(serializer.encode(m));
    }
  }

  @override
  void writeAll(Map<K, V> m) {
    if (_memory) {
      _memorymap.addAll(m);
    } else {
      var f = File(_path);
      var v = serializer.decode(f.readAsStringSync());
      v.addAll(m);
      f.writeAsString(serializer.encode(v));
    }
  }
}

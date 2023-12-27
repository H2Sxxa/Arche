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

  /// Read Only
  ArcheConfig.memory(
      {String init = "{}", MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    _memorymap.addAll(this.serializer.decode(init));
  }

  /// Read Only
  ArcheConfig.asset(String name, {MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    rootBundle
        .loadString(name)
        .then((value) => _memorymap.addAll(this.serializer.decode(value)));
  }

  /// Read / Write
  ArcheConfig.path(this._path, {MapSerializer<K, V, String>? serializer}) {
    if (serializer != null) {
      this.serializer = serializer;
    }

    if (!File(_path).existsSync()) {
      File(_path).writeAsStringSync("{}");
    }

    syncFrom();
  }

  void loads(String data) {
    _memorymap.addAll(this.serializer.decode(data));
  }

  /// Write
  void syncTo() {
    if (!_memory) {
      File(_path).writeAsStringSync(serializer.encode(_memorymap));
    }
  }

  /// Write
  void syncFrom() {
    if (!_memory) {
      _memorymap.addAll(this.serializer.decode(File(_path).readAsStringSync()));
    }
  }

  /// Read / Write
  @override
  Map<K, V> read() {
    return _memorymap;
  }

  /// Write
  @override
  void write(K key, V value) {
    _memorymap[key] = value;
    syncTo();
  }

  /// Write
  @override
  void writeAll(Map<K, V> m) {
    _memorymap.addAll(m);
    syncTo();
  }

  /// Read / Write
  @override
  void delkey(K key) {
    _memorymap.remove(key);
    syncTo();
  }
}

import 'dart:io';

import 'package:arche/arche.dart';
import 'package:arche/src/abc/kvrw.dart';
import 'package:flutter/services.dart';

class ConfigEntry<V> with BaseIO<V> {
  final ArcheConfig config;
  final String key;
  const ConfigEntry(this.config, this.key);

  @override
  void delete() => config.delete(key);

  @override
  V get() => config.get(key);

  @override
  bool has() => config.has(key);

  @override
  void write(V value) => config.write(key, value);

  static ConfigEntry<T> Function<T>(String key) withConfig(ArcheConfig config) {
    currying<T>(String key) => ConfigEntry<T>(config, key);
    return currying;
  }
}

class ConfigEntryConverter<T, R> with BaseIO<R> {
  final ConfigEntry<T> entry;
  final R Function(T value) forward;
  final T Function(R value) reverse;
  const ConfigEntryConverter(
    this.entry, {
    required this.forward,
    required this.reverse,
  });
  @override
  void delete() => entry.delete();

  @override
  R get() => forward(entry.get());

  @override
  bool has() => entry.has();

  @override
  void write(R value) => entry.write(reverse(value));
}

class ArcheConfig<K, V> extends Subordinate<ArcheConfig<K, V>> with KVIO<K, V> {
  @override
  TypeProvider get provider => ArcheBus();

  late MapSerializer<K, V, String> serializer = JsonSerializer();
  bool _memory = false;
  final Map<K, V> _memorymap = {};
  late File _file;

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
  ArcheConfig.path(String path, {MapSerializer<K, V, String>? serializer}) {
    if (serializer != null) {
      this.serializer = serializer;
    }
    _file = File(path);
    if (!_file.existsSync()) {
      _file.writeAsStringSync("{}");
    }

    syncFrom();
  }

  ArcheConfig.file(this._file, {MapSerializer<K, V, String>? serializer}) {
    if (serializer != null) {
      this.serializer = serializer;
    }

    if (!_file.existsSync()) {
      _file.writeAsStringSync("{}");
    }

    syncFrom();
  }

  void loads(String data) {
    _memorymap.addAll(this.serializer.decode(data));
  }

  /// Write
  void syncTo() {
    if (!_memory) {
      _file.writeAsStringSync(serializer.encode(_memorymap));
    }
  }

  /// Write
  void syncFrom() {
    if (!_memory) {
      _memorymap.addAll(this.serializer.decode(_file.readAsStringSync()));
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
  void delete(K key) {
    _memorymap.remove(key);
    syncTo();
  }
}

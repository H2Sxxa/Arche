import 'dart:async';
import 'dart:io';

import 'package:arche/arche.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef ConfigEntryGenerator = ConfigEntry<T> Function<T>(String key);

@immutable
abstract class AppConfigsBase {
  final ConfigEntryGenerator generator;

  AppConfigsBase(ArcheConfig config, [bool generateMap = false])
      : generator = ConfigEntry.withConfig(config, generateMap: generateMap);
}

class ConfigEntry<V> with BaseIO<V>, AsyncBaseIO<V> {
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

  static ConfigEntryGenerator withConfig(
    ArcheConfig config, {
    bool generateMap = false,
  }) {
    if (generateMap) {
      Map<String, ConfigEntry> map = {};
      currying<T>(String key) {
        var hashkey = "$key${T.hashCode}";
        return map.containsKey(hashkey)
            ? map[hashkey] as ConfigEntry<T>
            : map[hashkey] = ConfigEntry<T>(config, key);
      }

      return currying;
    } else {
      currying<T>(String key) => ConfigEntry<T>(config, key);
      return currying;
    }
  }

  @override
  FutureOr<void> deleteAsync() async => await config.deleteAsync(key);

  @override
  FutureOr<V> getAsync() async => await config.getAsync(key);

  @override
  FutureOr<bool> hasAsync() async => await config.hasAsync(key);

  @override
  FutureOr<void> writeAsync(V value) async =>
      await config.writeAsync(key, value);
}

class ConfigEntryConverter<T, R> with BaseIO<R>, AsyncBaseIO<R> {
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

  @override
  FutureOr<void> deleteAsync() async => await entry.deleteAsync();

  @override
  FutureOr<R> getAsync() async => forward(await entry.getAsync());

  @override
  FutureOr<bool> hasAsync() async => await entry.hasAsync();
  @override
  FutureOr<void> writeAsync(R value) async =>
      await entry.writeAsync(reverse(value));
}

class ArcheConfig<K, V> extends Subordinate<ArcheConfig<K, V>>
    with KVIO<K, V>, AsyncKVIO<K, V> {
  @override
  TypeProvider get provider => ArcheBus();

  late MapSerializer<K, V, String> serializer = JsonSerializer();
  bool _memory = false;
  final Map<K, V> _internal = {};
  late File _file;

  /// Read Only
  ArcheConfig.memory(
      {String init = "{}", MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    _internal.addAll(this.serializer.decode(init));
  }

  /// Read Only
  ArcheConfig.asset(String name, {MapSerializer<K, V, String>? serializer}) {
    _memory = true;

    if (serializer != null) {
      this.serializer = serializer;
    }

    rootBundle
        .loadString(name)
        .then((value) => _internal.addAll(this.serializer.decode(value)));
  }

  /// Read / Write
  ArcheConfig.path(String path,
      {MapSerializer<K, V, String>? serializer, bool initSync = true}) {
    if (serializer != null) {
      this.serializer = serializer;
    }
    _file = File(path);
    if (!_file.existsSync()) {
      _file.writeAsStringSync("{}");
    }

    if (initSync) {
      syncFrom();
    }
  }

  ArcheConfig.file(this._file,
      {MapSerializer<K, V, String>? serializer, bool initSync = true}) {
    if (serializer != null) {
      this.serializer = serializer;
    }

    if (!_file.existsSync()) {
      _file.writeAsStringSync("{}");
    }

    if (initSync) {
      syncFrom();
    }
  }

  void loads(String data) {
    _internal.addAll(this.serializer.decode(data));
  }

  /// Write
  void syncTo() {
    if (!_memory) {
      _file.writeAsStringSync(serializer.encode(_internal));
    }
  }

  FutureOr<void> syncToAsync() async {
    if (!_memory) {
      await _file.writeAsString(serializer.encode(_internal));
    }
  }

  /// Write
  void syncFrom() {
    if (!_memory) {
      _internal.addAll(this.serializer.decode(_file.readAsStringSync()));
    }
  }

  FutureOr<void> syncFromAsync() async {
    if (!_memory) {
      _internal.addAll(this.serializer.decode(await _file.readAsString()));
    }
  }

  /// Read / Write
  @override
  Map<K, V> read() {
    return _internal;
  }

  /// Write
  @override
  void write(K key, V value) {
    _internal[key] = value;
    syncTo();
  }

  /// Write
  @override
  void writeAll(Map<K, V> m) {
    _internal.addAll(m);
    syncTo();
  }

  /// Read / Write
  @override
  void delete(K key) {
    _internal.remove(key);
    syncTo();
  }

  @override
  FutureOr<void> deleteAsync(K key) async {
    _internal.remove(key);
    await syncToAsync();
  }

  @override
  FutureOr<Map<K, V>> readAsync() {
    return _internal;
  }

  @override
  FutureOr<void> writeAsync(K key, V value) async {
    _internal[key] = value;
    await syncToAsync();
  }
}

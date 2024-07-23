import 'dart:async';

abstract mixin class BaseIO<V> {
  void delete();

  void write(V value);

  V get();

  V getOr(V other) {
    if (has()) {
      return get();
    }
    return other;
  }

  V getOrWrite(V other) {
    if (has()) {
      return get();
    }
    write(other);
    return other;
  }

  V? tryGet() {
    if (has()) {
      return get();
    }
    return null;
  }

  bool has();
}

abstract mixin class AsyncBaseIO<V> {
  FutureOr<void> deleteAsync();

  FutureOr<void> writeAsync(V value);

  FutureOr<V> getAsync();

  FutureOr<V> getOrAsync(V other) async {
    if (await hasAsync()) {
      return getAsync();
    }
    return other;
  }

  FutureOr<V> getOrWriteAsync(V other) async {
    if (await hasAsync()) {
      return getAsync();
    }
    writeAsync(other);
    return other;
  }

  FutureOr<V?> tryGetAsync() async {
    if (await hasAsync()) {
      return getAsync();
    }
    return null;
  }

  FutureOr<bool> hasAsync();
}

abstract mixin class KVIO<K, V> {
  Map<K, V> read();
  void write(K key, V value);
  void delete(K key);
  void writeAll(Map<K, V> m) {
    for (var e in m.entries) {
      write(e.key, e.value);
    }
  }

  V get(K key) {
    return read()[key]!;
  }

  V? tryGet(K key) {
    return read()[key];
  }

  bool has(K key) {
    return read().containsKey(key);
  }

  V getOr(K key, V value) {
    if (has(key)) {
      return get(key);
    } else {
      return value;
    }
  }

  void fill(K key, V value) {
    if (!has(key)) {
      write(key, value);
    }
  }

  V getOrWrite(K key, V value) {
    if (has(key)) {
      return get(key);
    } else {
      write(key, value);
      return value;
    }
  }
}

abstract mixin class AsyncKVIO<K, V> {
  FutureOr<Map<K, V>> readAsync();
  FutureOr<void> writeAsync(K key, V value);
  FutureOr<void> deleteAsync(K key);
  FutureOr<void> writeAllAsync(Map<K, V> m) async {
    for (var e in m.entries) {
      await writeAsync(e.key, e.value);
    }
  }

  FutureOr<V> getAsync(K key) async {
    return (await readAsync())[key]!;
  }

  FutureOr<V?> tryGetAsync(K key) async {
    return (await readAsync())[key];
  }

  FutureOr<bool> hasAsync(K key) async {
    return (await readAsync()).containsKey(key);
  }

  FutureOr<V> getOrAsync(K key, V value) async {
    if (await hasAsync(key)) {
      return getAsync(key);
    } else {
      return value;
    }
  }

  void fillAsync(K key, V value) async {
    if (!await hasAsync(key)) {
      writeAsync(key, value);
    }
  }

  FutureOr<V> getOrWriteAsync(K key, V value) async {
    if (await hasAsync(key)) {
      return getAsync(key);
    } else {
      await writeAsync(key, value);
      return value;
    }
  }
}

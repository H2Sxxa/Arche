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

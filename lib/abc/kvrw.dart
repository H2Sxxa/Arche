abstract mixin class KVIO<K, V> {
  Map<K, V> read();
  void write(K key, V value);
  void writeAll(Map<K, V> m) {}

  V get(K key) {
    return read()[key]!;
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

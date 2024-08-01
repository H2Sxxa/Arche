class Translator<T, R> {
  final Map<T, R?> _internalMap = {};
  final Iterable<T> keys;
  late R _defautValue;

  Iterable<MapEntry<T, R?>> get iterator => _internalMap.entries;
  int get length => keys.length;
  Iterable<R?> get values => _internalMap.values;
  Translator(this.keys);

  Translator<T, R> defaultValue(R translate) {
    _defautValue = translate;
    return this;
  }

  Translator<T, R> translate(T target, R translate) {
    _internalMap[target] = translate;
    return this;
  }

  R? translation(T target) {
    var res = _internalMap[target];
    if (res == null) {
      assert(_defautValue != null);
      return _defautValue;
    }
    return res;
  }
}

typedef StringTranslator<T> = Translator<T, String>;

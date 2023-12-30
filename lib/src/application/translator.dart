class Translator<T, R> {
  Map<T, R?> values = {};
  late R _defautValue;
  late final int length;

  Translator(List<T> values) {
    this.values.addAll({for (var k in values) k: null});
    length = values.length;
  }

  Iterable<MapEntry<T, R?>> get iterator => values.entries;

  Translator<T, R> translate(T target, R translate) {
    values[target] = translate;
    return this;
  }

  Translator<T, R> defaultValue(R translate) {
    _defautValue = translate;
    return this;
  }

  R? getTranslate(T target) {
    var res = values[target];
    if (res == null) {
      return _defautValue;
    }
    return res;
  }
}

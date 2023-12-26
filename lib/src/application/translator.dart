class Translator<T, R> {
  Map<T, R?> values = {};
  late R _defautValue;
  Translator(List<T> values) {
    this.values.addAll({for (var k in values) k: null});
  }

  Translator translate(T target, R translate) {
    values[target] = translate;
    return this;
  }

  Translator defaultValue(R translate) {
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

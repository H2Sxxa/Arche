import 'package:arche/abc/typed.dart';

extension ListExt<T> on List<T> {
  List<T> addThen(T value) {
    add(value);
    return this;
  }

  List<T> addAllThen(Iterable<T> value) {
    addAll(value);
    return this;
  }

  List<T> joinElement(T separator) {
    if (length >= 2) {
      var tar = length - 1;
      for (var i = 0; i < tar; i++) {
        insert(1 + 2 * i, separator);
      }
    }
    return this;
  }
}

extension IterExt<T> on Iterable<T> {
  bool all({T? other}) {
    var test = other == null
        ? (T v) => v == (T == bool ? true : null)
        : (T v) => other == v;

    for (var i in this) {
      if (!test(i)) {
        return false;
      }
    }
    return true;
  }

  bool satisify(Test<T> test) {
    for (var i in this) {
      if (!test(i)) {
        return false;
      }
    }
    return true;
  }
}

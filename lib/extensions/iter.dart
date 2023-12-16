import 'package:arche/extensions/functions.dart';

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

  List<T> insertThen(int index, T value) {
    insert(index, value);
    return this;
  }

  static List<R> generatefrom<T, R>(Iterable<T> input,
      {FunctionFactory<T, R>? functionFactory}) {
    List<R> res = [];
    for (var e in input) {
      res.add(functionFactory != null ? functionFactory(e) : e as R);
    }
    return res;
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

  bool satisify(Predicate<T> predicate) {
    for (var i in this) {
      if (!predicate.test(i)) {
        return false;
      }
    }
    return true;
  }
}

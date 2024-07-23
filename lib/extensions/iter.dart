import 'package:arche/extensions/functions.dart';

extension ListExt<T> on List<T> {
  List<T> joinElement(T separator) {
    if (length >= 2) {
      var tar = length - 1;
      for (var i = 0; i < tar; i++) {
        insert(1 + 2 * i, separator);
      }
    }
    return this;
  }

  static List<R> generateFrom<T, R>(Iterable<T> input,
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

  List<R> enumerate<R>(FunctionIndexedFactory<T, R> functionFactory) {
    List<R> result = [];
    for (var (index, value) in indexed) {
      result.add(functionFactory(index, value));
    }
    return result;
  }
}

extension ItorExt<T> on Iterator<T> {
  T? next() {
    return moveNext() ? current : null;
  }
}

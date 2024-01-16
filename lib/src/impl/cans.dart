import 'package:arche/arche.dart';

class MutableCan<T> {
  const MutableCan();
  static final Map _cans = {};
  T get value => _cans[hashCode];
  set value(T val) => _cans[hashCode] = val;
  Optional<T> get optValue => Optional(value: value);

  void setValue(T value) {
    _cans[hashCode] = value;
  }
}

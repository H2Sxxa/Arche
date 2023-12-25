import 'package:arche/arche.dart';

class MutableCans<T> {
  MutableCans();
  static final Map _cans = {};
  T get value => _cans[hashCode];
  Optional<T> get optValue => Optional(value: value);
  void setValue(T value) {
    _cans[hashCode] = value;
  }
}

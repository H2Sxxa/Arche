import 'package:arche/extensions/functions.dart';

class Optional<V> {
  final V? value;

  static Optional<R> empty<R>() => const Optional().cast();

  const Optional({this.value});

  Optional<R> cast<R>() {
    return Optional<R>(value: value as R?);
  }

  bool isSome() {
    return value != null;
  }

  bool isNull() {
    return value == null;
  }

  R? ifNull<R>(R Function(V value) function) {
    return isNull() ? null : function(value as V);
  }

  R? ifSome<R>(R Function(V value) function) {
    return isSome() ? null : function(value as V);
  }

  V orElse(V defaultValue) {
    return value ?? defaultValue;
  }

  V orElseGet(FunctionCallback<V> other) {
    return value ?? other();
  }
}

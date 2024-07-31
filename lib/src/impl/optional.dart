import 'package:arche/extensions/functions.dart';
import 'package:flutter/foundation.dart';

@immutable
class Optional<V> {
  final V? _value;
  const Optional({V? value}) : _value = value;
  const Optional.some(V value) : _value = value;
  const Optional.none() : _value = null;

  Optional<R> cast<R>() {
    return Optional<R>(value: _value as R?);
  }

  static Optional<V> from<V>(V? value) {
    if (value == null) {
      return const Optional.none();
    }

    return Optional.some(value);
  }

  bool isSome() {
    return _value != null;
  }

  bool isNull() {
    return _value == null;
  }

  R? ifNull<R>(FunctionFactory<V, R> function) {
    return isNull() ? null : function(_value as V);
  }

  R? ifSome<R>(FunctionFactory<V, R> function) {
    return isSome() ? null : function(_value as V);
  }

  V get() {
    return _value!;
  }

  V orElse(V defaultValue) {
    return _value ?? defaultValue;
  }

  V orElseGet(FunctionCallback<V> other) {
    return _value ?? other();
  }

  Optional<R> factory<R>(FunctionFactory<V?, R> func) {
    return Optional(value: func(_value));
  }

  Optional<R> factoryGet<R>(FunctionFactory<V, R> func) {
    return Optional(value: func(get()));
  }

  Optional<R> factoryIfGet<R>(FunctionFactory<V, R> func) {
    return isNull() ? const Optional.none() : Optional(value: func(get()));
  }

  Optional<V> transform(Transformer<V> func) {
    return isNull() ? const Optional.none() : Optional(value: func(get()));
  }
}

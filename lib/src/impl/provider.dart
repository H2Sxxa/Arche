import 'package:arche/src/impl/widgets.dart';
import 'package:flutter/widgets.dart';

class TypeProvider {
  final Map _data = {};
  TypeProvider provide<T>(T instance) {
    if (!_data.containsKey(T.hashCode)) {
      _data[T.hashCode] = instance;
    }
    return this;
  }

  void replace<T>(T instance) {
    _data[T.hashCode] = instance;
  }

  T provideof<T>({T? instance}) {
    if (instance != null) {
      provide<T>(instance);
    }
    return of<T>();
  }

  T of<T>() {
    if (!has<T>()) {
      throw Exception("Instanceof <${T.toString()}> used before providing!");
    }

    return Subordinate.check(_data[T.hashCode], this);
  }

  bool has<T>() {
    return _data.containsKey(T.hashCode);
  }

  Widget toWidget(Widget child) {
    return ValueWrapper(this, child: child);
  }
}

class Subordinate<T extends Subordinate<dynamic>> {
  TypeProvider? provider;
  Subordinate() {
    if (provider != null) {
      provider!.provideof<T>(instance: this as T);
    }
  }

  static T check<T>(T value, TypeProvider provider) {
    if (value is Subordinate) {
      value.provider = provider;
    }
    return value;
  }

  R relevant<R>() {
    return provider!.of<R>();
  }
}

class SubordinateWrapper<T> extends Subordinate {
  final T _inner;
  SubordinateWrapper(this._inner);

  T get() {
    return _inner;
  }
}

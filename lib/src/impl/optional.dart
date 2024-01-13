import 'package:arche/extensions/functions.dart';

class Optional<V> {
  late final V? _inner;

  final Optional<void> empty = Optional(value: null);

  Optional({V? value}) {
    _inner = value;
  }

  bool isSome() {
    return _inner != null;
  }

  bool isNull() {
    return _inner == null;
  }

  R? ifNull<R>(R Function(V value) function) {
    return isNull() ? null : function(value);
  }

  R? ifSome<R>(R Function(V value) function) {
    return isSome() ? null : function(value);
  }

  V get value => _inner!;
  V orElse(V defaultValue) {
    return _inner ?? defaultValue;
  }

  V orElseGet(FunctionCallback<V> other) {
    return _inner ?? other();
  }
}

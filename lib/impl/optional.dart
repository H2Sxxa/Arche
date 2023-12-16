
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

  V get get => _inner!;
  V orElse(V defaultValue) {
    return _inner ?? defaultValue;
  }

  V orElseGet(FunctionCallback<V> other) {
    return _inner ?? other();
  }
}

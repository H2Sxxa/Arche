import 'package:arche/arche.dart';

class ConstCan<T> {
  static final Map<int, dynamic> _fields = {};
  final dynamic id;
  const ConstCan([this.id]);
  T? get value => _fields[id.hashCode];
  set value(value) => _fields[id.hashCode] = value;
  Optional<T> get optValue => Optional(value: value);
}

class LazyCan<T> extends ConstCan<T> {
  final T Function() builder;
  const LazyCan({required this.builder}) : super(builder);
  @override
  T get value => super.value ?? reload();

  T reload() {
    super.value = builder();
    return value;
  }
}

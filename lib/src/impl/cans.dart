import 'package:arche/arche.dart';
import 'package:flutter/widgets.dart';

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
    value = builder();
    return value;
  }
}

class FutureLazyCan<T> extends ConstCan<T> {
  final Future<T> Function() builder;
  const FutureLazyCan({required this.builder}) : super(builder);
  @override
  T? get value {
    if (super.value != null) {
      return super.value;
    }
    reload().then((value) => this.value = value);
    return null;
  }

  Future<T> reload() async {
    value = await builder();

    return value!;
  }

  Widget widgetBuilder(AsyncWidgetBuilder builder, {bool refresh = false}) {
    return FutureBuilder(
      future: refresh
          ? reload()
          : Future(() async {
              if (super.value != null) {
                return super.value as T;
              }
              return await reload();
            }),
      builder: builder,
    );
  }
}

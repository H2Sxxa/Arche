import 'package:arche/arche.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ConstCan<T> {
  static final Map<int, dynamic> _fields = {};
  final dynamic id;
  const ConstCan([this.id]);
  T? get value => _fields[id.hashCode];
  set value(value) => _fields[id.hashCode] = value;
  Optional<T> get optValue => Optional(value: value);
}

class LazyConstCan<T> extends ConstCan<T> {
  final ValueGetter<T> builder;
  const LazyConstCan({required this.builder}) : super(builder);
  @override
  T get value => super.value ?? reload();

  T reload() {
    value = builder();
    return value;
  }
}

class FutureLazyConstCan<T> extends ConstCan<T> {
  final AsyncValueGetter<T> builder;
  const FutureLazyConstCan({required this.builder}) : super(builder);
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

  Future<T> getValue() async {
    if (value != null) {
      return value!;
    }

    return await reload();
  }

  Widget widgetBuilder(AsyncWidgetBuilder builder, {bool refresh = false}) {
    return FutureBuilder(
      future: refresh
          ? reload()
          : Future(() async {
              var recent = super.value;
              if (recent != null) {
                return recent;
              }
              return await reload();
            }),
      builder: builder,
    );
  }
}

class DynamicCan<T> {
  T? value;
  DynamicCan([this.value]);
  Optional<T> get optValue => Optional(value: value);
}

class LazyDynamicCan<T> extends DynamicCan<T> {
  final ValueGetter<T> builder;
  LazyDynamicCan({required this.builder});

  @override
  T get value => super.value ?? reload();

  T reload() {
    value = builder();
    return value!;
  }
}

class FutureLazyDynamicCan<T> extends DynamicCan<T> {
  final AsyncValueGetter builder;

  FutureLazyDynamicCan({required this.builder});

  Future<T> reload() async {
    value = await builder();
    return value!;
  }

  Future<T> getValue() async {
    if (value != null) {
      return value!;
    }

    return await reload();
  }

  Widget widgetBuilder(AsyncWidgetBuilder builder, {bool refresh = false}) {
    return FutureBuilder(
      future: refresh
          ? reload()
          : Future(() async {
              var recent = super.value;
              if (recent != null) {
                return recent;
              }
              return await reload();
            }),
      builder: builder,
    );
  }
}

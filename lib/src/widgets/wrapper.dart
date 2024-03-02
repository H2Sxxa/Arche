import 'package:flutter/widgets.dart';

typedef ValueStateBuilderFunction<V, R> = R Function(
    BuildContext context, ValueStateBuilderState<V> state);

class ValueStateBuilder<V> extends StatefulWidget {
  final ValueStateBuilderFunction<V, Widget> builder;
  final ValueStateBuilderFunction<V, dynamic>? onInit;
  final V init;

  const ValueStateBuilder({
    required this.builder,
    required this.init,
    this.onInit,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ValueStateBuilderState<V>();
}

class ValueStateBuilderState<V> extends State<ValueStateBuilder<V>> {
  late V value;

  @override
  void initState() {
    super.initState();
    value = widget.init;
    var onInit = widget.onInit;
    if (onInit != null) {
      onInit(context, this);
    }
  }

  void update(V value) {
    setState(() {
      this.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}

@immutable
class FutureResolver<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(Object? error, StackTrace? stackTrace)? error;
  final Widget Function(T? value)? data;
  final Widget? loading;
  const FutureResolver({
    super.key,
    this.future,
    this.data,
    this.error,
    this.loading,
  });

  FutureResolver<T> copy({
    Key? key,
    Future<T>? future,
    Widget Function(T? value)? data,
    Widget Function(Object? error, StackTrace? stackTrace)? error,
    Widget? loading,
  }) =>
      FutureResolver(
        key: key ?? this.key,
        future: future ?? this.future,
        data: data ?? this.data,
        error: error ?? this.error,
        loading: loading ?? this.loading,
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return data!(snapshot.data);
        }

        if (snapshot.hasError) {
          return (error ?? (error, stacktrace) => Text("$error\n$stacktrace"))(
              snapshot.error, snapshot.stackTrace);
        }

        return loading ?? const SizedBox.shrink();
      },
    );
  }
}

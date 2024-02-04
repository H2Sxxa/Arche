import 'package:flutter/widgets.dart';

typedef ValueStateBuilderFunction<V, R> = R Function(
    BuildContext context, StateValueStateBuilder<V> state);

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
  State<StatefulWidget> createState() => StateValueStateBuilder<V>();
}

class StateValueStateBuilder<V> extends State<ValueStateBuilder<V>> {
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

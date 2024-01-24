import 'package:flutter/widgets.dart';

typedef ValueStateBuilderFunction<V, R> = R Function(
    BuildContext context, StateValueStateBuilder<V> state);

class ValueStateBuilder<V> extends StatefulWidget {
  final ValueStateBuilderFunction<V, Widget> builder;
  final ValueStateBuilderFunction<V, dynamic>? initState;
  final V initial;

  const ValueStateBuilder({
    required this.builder,
    required this.initial,
    this.initState,
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
    value = widget.initial;
    var hooker = widget.initState;
    if (hooker != null) {
      hooker(context, this);
    }
  }

  void update(V value) {
    setState(() {
      value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}

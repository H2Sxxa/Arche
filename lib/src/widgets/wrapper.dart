import 'package:flutter/widgets.dart';

class ValueStateBuilder<V> extends StatefulWidget {
  final Widget Function(BuildContext context, V value, ValueChanged<V> update)
      builder;
  final V initial;
  const ValueStateBuilder(
      {required this.builder, required this.initial, super.key});

  @override
  State<StatefulWidget> createState() => StateValueStateBuilder<V>();
}

class StateValueStateBuilder<V> extends State<ValueStateBuilder<V>> {
  late V _value;
  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  void update(V value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value, update);
  }
}

class ConditionShrink extends StatelessWidget {
  final bool value;
  final Widget child;
  const ConditionShrink({super.key, required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return value ? child : const SizedBox.shrink();
  }
}

class ConditionBuilderShrink extends StatelessWidget {
  final bool Function() builder;
  final Widget child;
  const ConditionBuilderShrink(
      {super.key, required this.builder, required this.child});

  @override
  Widget build(BuildContext context) {
    return builder() ? child : const SizedBox.shrink();
  }
}

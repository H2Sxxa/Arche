import 'package:arche/src/widgets/mixin.dart';
import 'package:flutter/widgets.dart';

class ValueStateBuilder<V> extends StatefulWidget {
  final Widget Function(BuildContext context, V value,
      void Function({VoidCallback? fn}) refresh) builder;
  final V initial;
  const ValueStateBuilder(
      {required this.builder, required this.initial, super.key});

  @override
  State<StatefulWidget> createState() => StateValueStateBuilder();
}

class StateValueStateBuilder<V> extends State<ValueStateBuilder<V>>
    with MixinRefreshState<ValueStateBuilder<V>> {
  late V value;
  @override
  void initState() {
    super.initState();
    value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, value, refresh);
  }
}

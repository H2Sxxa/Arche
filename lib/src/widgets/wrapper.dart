import 'package:flutter/widgets.dart';

typedef WidgetValueUpdateChanged<V> = Widget Function(
  BuildContext context,
  V value,
  ValueChanged<V> update,
);

class ValueStateBuilder<V> extends StatefulWidget {
  final WidgetValueUpdateChanged<V> builder;
  final WidgetValueUpdateChanged<V>? initState;
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
  late V _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
    var hooker = widget.initState;
    if (hooker != null) {
      hooker(context, _value, update);
    }
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

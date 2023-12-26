import 'package:arche/src/impl/cans.dart';
import 'package:flutter/widgets.dart';

class WidgetWrapper extends StatefulWidget {
  final Widget inner;
  final MutableCans<StateWidgetWrapper> state = MutableCans();
  WidgetWrapper(this.inner, {super.key});

  @override
  State<StatefulWidget> createState() => StateWidgetWrapper();
}

class StateWidgetWrapper extends State<WidgetWrapper> {
  @override
  void initState() {
    super.initState();
    widget.state.setValue(this);
  }

  void refresh({VoidCallback? fn}) {
    setState(fn ?? () {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.inner;
  }
}

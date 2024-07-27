import 'package:flutter/widgets.dart';

mixin RefreshMountedStateMixin<T extends StatefulWidget> on State<T> {
  void refreshMounted() {
    if (mounted) {
      setState(() {});
    }
  }

  void refreshMountedFn(Function() fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

import 'package:flutter/widgets.dart';

mixin RefreshMountedStateMixin<T extends StatefulWidget> on State<T> {
  void refreshMounted([Function()? fn]) {
    if (mounted) {
      setState(fn ?? () {});
    }
  }

  void refreshMountedFn(Function() fn) {
    refreshMounted(fn);
  }
}

import 'package:flutter/material.dart';

mixin MixinRefreshState<T extends StatefulWidget> on State<T> {
  void refresh({VoidCallback? fn}) {
    setState(fn ?? () {});
  }
}

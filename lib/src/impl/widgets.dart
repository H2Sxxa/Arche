import 'package:flutter/widgets.dart';

class ValueWrapper extends StatelessWidget {
  final Widget child;
  final dynamic value;
  const ValueWrapper(this.value, {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

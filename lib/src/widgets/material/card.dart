import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureDoubleTapCallback? onDoubleTap;
  final Size size;
  final double? elevation;
  const CardButton({
    super.key,
    required this.child,
    required this.size,
    this.elevation,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox.fromSize(
          size: size,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

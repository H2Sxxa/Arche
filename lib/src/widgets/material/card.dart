import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureDoubleTapCallback? onDoubleTap;
  final Size? size;
  final double? elevation;
  final ShapeBorder? shape;
  final Color? color;
  const CardButton({
    super.key,
    required this.child,
    this.size,
    this.elevation,
    this.color,
    this.shape,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Card(
        elevation: elevation,
        shape: shape,
        color: color,
        child: InkWell(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

class CardMenuButton<T> extends StatelessWidget {
  final PopupMenuItemBuilder<T> itemBuilder;
  final Size? size;
  final double? elevation;
  final Color? color;
  final Widget? child;
  final PopupMenuPosition? position;
  final String? tooltip;
  final ShapeBorder? shape;
  const CardMenuButton({
    super.key,
    required this.itemBuilder,
    this.size,
    this.elevation,
    this.color,
    this.child,
    this.position,
    this.tooltip = "",
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Card(
        color: color,
        elevation: elevation,
        shape: shape,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<T>(
              itemBuilder: itemBuilder,
              tooltip: tooltip,
              position: position ?? PopupMenuPosition.under,
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

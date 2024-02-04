import 'dart:async';

import 'package:flutter/material.dart';

@immutable
class ComplexDialog<R> {
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool useSafeArea;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  /// If `builder` is null, the child will be `() => child ?? const SizedBox.shrink()`
  final WidgetBuilder? builder;
  final Widget? child;
  const ComplexDialog({
    this.anchorPoint,
    this.barrierColor,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.routeSettings,
    this.useRootNavigator = true,
    this.traversalEdgeBehavior,
    this.useSafeArea = true,
    this.builder,
    this.child,
  });

  ComplexDialog<R> withBuilder(WidgetBuilder builder) {
    return copy(builder: builder);
  }

  ComplexDialog<R> withChild(Widget child) {
    return copy(child: child);
  }

  ComplexDialog<R> copy({
    WidgetBuilder? builder,
    Widget? child,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool? useSafeArea,
    bool? useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return ComplexDialog(
      builder: builder ?? this.builder,
      child: child ?? this.child,
      barrierColor: barrierColor ?? this.barrierColor,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierLabel: barrierLabel ?? this.barrierLabel,
      traversalEdgeBehavior:
          traversalEdgeBehavior ?? this.traversalEdgeBehavior,
      anchorPoint: anchorPoint ?? this.anchorPoint,
      useSafeArea: useSafeArea ?? this.useSafeArea,
      useRootNavigator: useRootNavigator ?? this.useRootNavigator,
    );
  }

  FutureOr<R?> prompt({required BuildContext context}) {
    return showDialog<R>(
      context: context,
      builder: builder ?? (context) => child ?? const SizedBox.shrink(),
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      traversalEdgeBehavior: traversalEdgeBehavior,
      anchorPoint: anchorPoint,
      routeSettings: routeSettings,
      useRootNavigator: useRootNavigator,
      useSafeArea: useSafeArea,
    );
  }

  FutureOr<R?> block({required BuildContext context}) async {
    return await prompt(context: context);
  }
}

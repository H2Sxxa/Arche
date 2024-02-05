import 'dart:async';

import 'package:flutter/material.dart';

@immutable
class ComplexDialog {
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

  final BuildContext? context;
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
    this.context,
  });

  ComplexDialog withBuilder(WidgetBuilder builder) {
    return copy(builder: builder);
  }

  ComplexDialog withChild(Widget child) {
    return copy(child: child);
  }

  ComplexDialog withContext<R>({required BuildContext context}) {
    return copy(context: context);
  }

  ComplexDialog copy({
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
    BuildContext? context,
  }) {
    return ComplexDialog(
      builder: builder ?? this.builder,
      context: context ?? this.context,
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

  FutureOr<R?> prompt<R>({BuildContext? context}) {
    return showDialog<R>(
      context: context ?? this.context!,
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

  NavigatorState navigator(BuildContext? context) =>
      Navigator.of(context ?? this.context!);
}

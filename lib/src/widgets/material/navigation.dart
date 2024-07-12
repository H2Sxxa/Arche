import 'package:arche/src/impl/optional.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef NavBuilder = Widget Function(
  BuildContext context,
  Widget Function() vertical,
  Widget Function() horizontal,
  NavigationViewState state,
);

class HorizontalItemConfig {
  final Color? indicatorColor;
  final EdgeInsetsGeometry? padding;
  final ShapeBorder? indicatorShape;
  const HorizontalItemConfig({
    this.padding,
    this.indicatorColor,
    this.indicatorShape,
  });
}

class VerticalItemConfig {
  final Key? key;
  final String? tooltip;
  const VerticalItemConfig({
    this.key,
    this.tooltip,
  });
}

class NavigationItem {
  final Widget? selectedIcon;
  final Widget page, icon;

  /// Be used to `pushName`
  final String? name;

  final String label;
  final VerticalItemConfig? vertical;

  /// Be used in a horizontal View(Row)
  final HorizontalItemConfig? horizontal;

  /// The padding of the page
  final EdgeInsetsGeometry? padding;

  /// Indicates that this destination is selectable.
  ///
  /// Defaults to true.
  final bool enabled;
  const NavigationItem({
    required this.icon,
    required this.page,
    this.selectedIcon,
    this.name,
    this.label = "",
    this.padding,
    this.vertical,
    this.horizontal,
    this.enabled = true,
  });

  NavigationRailDestination buildHorizontal() {
    return NavigationRailDestination(
      icon: icon,
      selectedIcon: selectedIcon,
      label: Text(label),
      disabled: !enabled,
      indicatorColor: horizontal?.indicatorColor,
      indicatorShape: horizontal?.indicatorShape,
      padding: horizontal?.padding,
    );
  }

  NavigationDestination buildVertical() {
    return NavigationDestination(
      icon: icon,
      label: label,
      selectedIcon: selectedIcon,
      enabled: enabled,
      tooltip: vertical?.tooltip ?? "",
      key: vertical?.key,
    );
  }
}

enum NavigationLabelType {
  none,
  selected,
  all,
}

class NavigationHorizontalConfig {
  final double? groupAlignment;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final IconThemeData? unselectedIconTheme;
  final IconThemeData? selectedIconTheme;
  final double? minWidth;
  final double? minExtendedWidth;
  final bool? useIndicator;
  final bool initialExtended;
  final Widget? leading, trailing;
  const NavigationHorizontalConfig({
    this.leading,
    this.trailing,
    this.groupAlignment,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
    this.useIndicator,
    this.initialExtended = false,
  });
}

class NavigationVerticalConfig {
  final Color? shadowColor, surfaceTintColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? height;
  final Duration? animationDuration;
  const NavigationVerticalConfig({
    this.shadowColor,
    this.overlayColor,
    this.surfaceTintColor,
    this.height,
    this.animationDuration,
  });
}

class NavigationView extends StatefulWidget {
  final Key? navKey;
  final List<NavigationItem> items;
  final Duration? animationDuration;

  final Axis direction;
  final bool reversed;
  final NavigationHorizontalConfig? horizontal;
  final NavigationVerticalConfig? vertical;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final Color? backgroundColor;
  final double? elevation;
  final NavigationLabelType? labelType;
  final NavBuilder? builder;

  final ValueChanged<int>? onPageChanged;

  final bool showBar;

  /// usePageView == true
  final bool usePageView;
  final Curve? pageViewCurve;

  /// usePageView == false
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  final AnimatedSwitcherLayoutBuilder? layoutBuilder;

  const NavigationView({
    super.key,
    required this.items,
    this.navKey,
    this.transitionBuilder,
    this.animationDuration,
    this.direction = Axis.horizontal,
    this.reversed = false,
    this.horizontal,
    this.vertical,
    this.indicatorColor,
    this.indicatorShape,
    this.backgroundColor,
    this.elevation,
    this.labelType,
    this.switchInCurve,
    this.switchOutCurve,
    this.pageViewCurve,
    this.layoutBuilder,
    this.usePageView = false,
    this.builder,
    this.showBar = true,
    this.onPageChanged,
  });

  const NavigationView.switcher({
    super.key,
    this.navKey,
    required this.items,
    this.animationDuration,
    this.direction = Axis.horizontal,
    this.reversed = false,
    this.horizontal,
    this.vertical,
    this.indicatorColor,
    this.indicatorShape,
    this.backgroundColor,
    this.elevation,
    this.labelType,
    this.builder,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
    this.showBar = true,
    this.onPageChanged,
  })  : usePageView = false,
        pageViewCurve = null;

  const NavigationView.pageView({
    super.key,
    this.navKey,
    required this.items,
    this.animationDuration,
    this.direction = Axis.horizontal,
    this.reversed = false,
    this.horizontal,
    this.vertical,
    this.indicatorColor,
    this.indicatorShape,
    this.backgroundColor,
    this.elevation,
    this.labelType,
    this.pageViewCurve,
    this.builder,
    this.showBar = true,
    this.onPageChanged,
  })  : usePageView = true,
        switchInCurve = null,
        switchOutCurve = null,
        layoutBuilder = null,
        transitionBuilder = null;

  @override
  State<StatefulWidget> createState() => NavigationViewState();
}

class NavigationViewState extends State<NavigationView>
    with TickerProviderStateMixin, IndexedNavigatorStateMixin {
  late bool extended;
  late AnimationController animationIconCtrl;
  late PageController pageController;

  void pushName(String name) =>
      getIndex(name).ifSome((value) => pushIndex(value));

  Optional<int> getIndex(String name) {
    for (var element in widget.items.asMap().entries) {
      if (element.value.name == name) {
        return Optional(value: element.key);
      }
    }
    return const Optional.none();
  }

  void replaceName(String name) =>
      getIndex(name).ifSome((value) => replaceIndex(value));

  @override
  set currentIndex(int other) {
    super.currentIndex = other;
    var onPageChanged = widget.onPageChanged;
    if (onPageChanged != null) {
      onPageChanged(other);
    }
  }

  @override
  void initState() {
    super.initState();

    extended = widget.horizontal?.initialExtended ?? false;
    animationIconCtrl = AnimationController(vsync: this)
      ..duration = widget.animationDuration ?? Durations.medium4;

    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    animationIconCtrl.dispose();
    pageController.dispose();
  }

  Widget _buildVertical() {
    var config = widget.vertical;
    NavigationDestinationLabelBehavior labelType =
        NavigationDestinationLabelBehavior.onlyShowSelected;
    switch (widget.labelType) {
      case NavigationLabelType.all:
        labelType = NavigationDestinationLabelBehavior.alwaysShow;
        break;
      case NavigationLabelType.none:
        labelType = NavigationDestinationLabelBehavior.alwaysHide;
        break;
      default:
        break;
    }
    return NavigationBar(
      destinations: widget.items.map((e) => e.buildVertical()).toList(),
      onDestinationSelected: pushIndex,
      selectedIndex: currentIndex,
      elevation: widget.elevation,
      indicatorColor: widget.indicatorColor,
      backgroundColor: widget.backgroundColor,
      indicatorShape: widget.indicatorShape,
      shadowColor: config?.shadowColor,
      overlayColor: config?.overlayColor,
      surfaceTintColor: config?.surfaceTintColor,
      height: config?.height,
      animationDuration: config?.animationDuration,
      key: widget.navKey,
      labelBehavior: labelType,
    );
  }

  Widget _buildHorizontal() {
    var config = widget.horizontal;
    NavigationRailLabelType labelType = NavigationRailLabelType.none;
    switch (widget.labelType) {
      case NavigationLabelType.all:
        labelType = NavigationRailLabelType.all;
        break;
      case NavigationLabelType.selected:
        labelType = NavigationRailLabelType.selected;
        break;
      default:
        break;
    }
    Widget? leading = config?.leading ??
        IconButton(
          onPressed: () => setState(() {
            extended = !extended;
            extended
                ? animationIconCtrl.forward()
                : animationIconCtrl.reverse();
          }),
          icon: Transform.rotate(
            angle: widget.reversed ? math.pi : 0,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: animationIconCtrl,
            ),
          ),
        );
    if (config?.leading == null && labelType != NavigationRailLabelType.none) {
      leading = null;
    }

    return NavigationRail(
      leading: leading,
      extended: extended,
      selectedLabelTextStyle: config?.selectedLabelTextStyle,
      unselectedLabelTextStyle: config?.unselectedLabelTextStyle,
      unselectedIconTheme: config?.unselectedIconTheme,
      trailing: config?.trailing,
      destinations: widget.items.map((e) => e.buildHorizontal()).toList(),
      onDestinationSelected: pushIndex,
      selectedIndex: currentIndex,
      key: widget.navKey,
      selectedIconTheme: config?.selectedIconTheme,
      labelType: extended ? NavigationRailLabelType.none : labelType,
      indicatorColor: widget.indicatorColor,
      backgroundColor: widget.backgroundColor,
      indicatorShape: widget.indicatorShape,
      groupAlignment: config?.groupAlignment,
      minExtendedWidth: config?.minExtendedWidth,
      minWidth: config?.minWidth,
      useIndicator: config?.useIndicator,
      elevation: widget.elevation,
    );
  }

  static Widget defaultBuilder(
    BuildContext context,
    Widget Function() vertical,
    Widget Function() horizontal,
    NavigationViewState state,
  ) {
    var view = state.widget;
    var isHorizontal = view.direction == Axis.horizontal;
    var children = isHorizontal
        ? [
            Visibility(visible: state.widget.showBar, child: horizontal()),
            state.content
          ]
        : [
            state.content,
            Visibility(visible: state.widget.showBar, child: vertical()),
          ];
    if (view.reversed) {
      children = children.reversed.toList();
    }

    return isHorizontal ? Row(children: children) : Column(children: children);
  }

  @override
  void pushIndex(int index) {
    super.pushIndex(index);
    if (widget.usePageView) {
      pageController.animateToPage(
        index,
        duration: widget.animationDuration ?? Durations.medium4,
        curve: widget.pageViewCurve ?? Curves.fastLinearToSlowEaseIn,
      );
    }
  }

  @override
  int? popIndex() {
    var index = super.popIndex();
    if (index != null && widget.usePageView) {
      pageController.animateToPage(
        index,
        duration: widget.animationDuration ?? Durations.medium4,
        curve: widget.pageViewCurve ?? Curves.linear,
      );
    }
    return index;
  }

  Widget get content => Expanded(
        child: Padding(
          padding: widget.items[currentIndex].padding ?? EdgeInsets.zero,
          child: widget.usePageView
              ? PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (value) => super.pushIndex(value),
                  children: widget.items.map((e) => e.page).toList(),
                )
              : AnimatedSwitcher(
                  duration: widget.animationDuration ?? Durations.medium4,
                  switchInCurve: widget.switchInCurve ?? Curves.linear,
                  switchOutCurve: widget.switchOutCurve ?? Curves.linear,
                  transitionBuilder: widget.transitionBuilder ??
                      AnimatedSwitcher.defaultTransitionBuilder,
                  layoutBuilder: widget.layoutBuilder ??
                      AnimatedSwitcher.defaultLayoutBuilder,
                  child: widget.items[currentIndex].page),
        ),
      );
  @override
  Widget build(BuildContext context) {
    NavBuilder builder = widget.builder ?? defaultBuilder;
    return builder(
      context,
      _buildVertical,
      _buildHorizontal,
      this,
    );
  }
}

mixin IndexedNavigatorStateMixin<T extends StatefulWidget> on State<T> {
  int currentIndex = 0;
  final List<int> recentIndexs = [];

  void pushIndex(int index) {
    setState(() {
      recentIndexs.add(currentIndex);
      currentIndex = index;
    });
  }

  int? popIndex() {
    if (recentIndexs.isNotEmpty) {
      var index = recentIndexs.removeLast();
      setState(() {
        currentIndex = index;
      });
      return index;
    }
    return null;
  }

  void replaceIndex(int index) {
    setState(() {
      if (recentIndexs.isNotEmpty) {
        recentIndexs.last = index;
      }
      currentIndex = index;
    });
  }
}

import 'package:arche/src/impl/optional.dart';
import 'package:flutter/material.dart';

typedef NavBuilder = Widget Function(
  BuildContext context,
  Widget Function() vertical,
  Widget Function() horizontal,
  StateNavigationView state,
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
  final MaterialStateProperty<Color?>? overlayColor;
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
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  final Duration? switchDuration;
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
  const NavigationView({
    super.key,
    required this.items,
    this.navKey,
    this.transitionBuilder,
    this.switchDuration,
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
  });

  @override
  State<StatefulWidget> createState() => StateNavigationView();
}

class StateNavigationView extends State<NavigationView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List _pastIndex = [];
  late bool extended;
  late AnimationController animationIconCtrl;

  void pushName(String name) =>
      getIndex(name).ifSome((value) => pushIndex(value));

  Optional<int> getIndex(String name) {
    for (var element in widget.items.asMap().entries) {
      if (element.value.name == name) {
        return Optional(value: element.key);
      }
    }
    return Optional();
  }

  void pushIndex(int index) {
    setState(() {
      _pastIndex.add(_currentIndex);
      _currentIndex = index;
    });
  }

  void pop() {
    if (_pastIndex.isNotEmpty) {
      setState(() => _currentIndex = _pastIndex.removeLast());
    }
  }

  void replace(int index) {
    setState(() {
      if (_pastIndex.isNotEmpty) {
        _pastIndex.last = index;
      }
      _currentIndex = index;
    });
  }

  void replaceName(String name) =>
      getIndex(name).ifSome((value) => replace(value));

  @override
  void initState() {
    super.initState();

    extended = widget.horizontal?.initialExtended ?? false;
    animationIconCtrl = AnimationController(vsync: this)
      ..duration = Durations.medium4;
  }

  @override
  void dispose() {
    super.dispose();
    animationIconCtrl.dispose();
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
      selectedIndex: _currentIndex,
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
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: animationIconCtrl,
            ));
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
      selectedIndex: _currentIndex,
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
    StateNavigationView state,
  ) {
    var view = state.widget;
    var isHorizontal = view.direction == Axis.horizontal;
    var children = isHorizontal
        ? [horizontal(), state.content]
        : [state.content, vertical()];
    if (view.reversed) {
      children = children.reversed.toList();
    }

    return isHorizontal ? Row(children: children) : Column(children: children);
  }

  Widget get content => Expanded(
        child: Padding(
          padding:
              widget.items[_currentIndex].padding ?? const EdgeInsets.all(12),
          child: AnimatedSwitcher(
              duration: widget.switchDuration ?? Durations.medium4,
              transitionBuilder: widget.transitionBuilder ??
                  (child, animation) =>
                      AnimatedSwitcher.defaultTransitionBuilder(
                          child, animation),
              child: widget.items[_currentIndex].page),
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

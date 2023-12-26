import 'package:flutter/material.dart';

class NavigationItem extends NavigationRailDestination {
  Widget page;
  String? name;
  NavigationItem({
    required super.icon,
    required super.label,
    required this.page,
    this.name,
    super.disabled,
    super.indicatorColor,
    super.indicatorShape,
    super.padding,
    super.selectedIcon,
  });
}

class NavigationRailConfig {
  final Color? backgroundColor;
  final bool extended;
  final ValueChanged<int>? onDestinationSelected;
  final double? elevation;
  final double? groupAlignment;
  final NavigationRailLabelType? labelType;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final IconThemeData? unselectedIconTheme;
  final IconThemeData? selectedIconTheme;
  final double? minWidth;
  final double? minExtendedWidth;
  final bool? useIndicator;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final Key? key;
  const NavigationRailConfig({
    this.key,
    this.backgroundColor,
    this.extended = false,
    this.onDestinationSelected,
    this.elevation,
    this.groupAlignment,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth,
    this.minExtendedWidth,
    this.useIndicator,
    this.indicatorColor,
    this.indicatorShape,
  });
}

class NavigationView extends StatefulWidget {
  final List<NavigationItem> items;
  final Widget? leading, trailing;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  final Duration? switchDuration;
  final NavigationRailConfig? config;
  const NavigationView({
    super.key,
    required this.items,
    this.transitionBuilder,
    this.switchDuration,
    this.leading,
    this.trailing,
    this.config,
  });

  @override
  State<StatefulWidget> createState() => StateNavigationView();
}

class StateNavigationView extends State<NavigationView> {
  int _currentIndex = 0;
  void pushName(String name) {
    setState(() {
      for (var element in widget.items.asMap().entries) {
        if (element.value.name == name) {
          _currentIndex = element.key;
        }
      }
    });
  }

  Widget buildRail() {
    var rail = widget.config;
    if (rail != null) {
      return NavigationRail(
        key: rail.key,
        elevation: rail.elevation,
        indicatorColor: rail.indicatorColor,
        backgroundColor: rail.backgroundColor,
        indicatorShape: rail.indicatorShape,
        groupAlignment: rail.groupAlignment,
        minExtendedWidth: rail.minExtendedWidth,
        minWidth: rail.minWidth,
        useIndicator: rail.useIndicator,
        labelType: rail.labelType,
        unselectedIconTheme: rail.unselectedIconTheme,
        unselectedLabelTextStyle: rail.unselectedLabelTextStyle,
        selectedLabelTextStyle: rail.selectedLabelTextStyle,
        selectedIconTheme: rail.selectedIconTheme,
        leading: widget.leading,
        trailing: widget.trailing,
        destinations: widget.items,
        onDestinationSelected: (value) => setState(() {
          _currentIndex = value;
        }),
        selectedIndex: _currentIndex,
      );
    }
    return NavigationRail(
      leading: widget.leading,
      trailing: widget.trailing,
      destinations: widget.items,
      onDestinationSelected: (value) => setState(() {
        _currentIndex = value;
      }),
      selectedIndex: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildRail(),
        Expanded(
            child: AnimatedSwitcher(
                duration:
                    widget.switchDuration ?? const Duration(milliseconds: 500),
                transitionBuilder: widget.transitionBuilder ??
                    (child, animation) =>
                        AnimatedSwitcher.defaultTransitionBuilder(
                            child, animation),
                child: widget.items[_currentIndex].page)),
      ],
    );
  }
}

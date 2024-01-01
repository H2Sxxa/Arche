import 'package:flutter/material.dart';

class NavigationItem extends NavigationRailDestination {
  final Widget page;
  final String? name;
  final EdgeInsetsGeometry? pagePadding;
  const NavigationItem({
    required super.icon,
    required super.label,
    required this.page,
    this.name,
    super.disabled,
    super.indicatorColor,
    super.indicatorShape,
    super.selectedIcon,
    this.pagePadding,
  });
}

class NavigationRailConfig {
  final Color? backgroundColor;
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
  final bool initialExtended;
  const NavigationView({
    super.key,
    required this.items,
    this.transitionBuilder,
    this.switchDuration,
    this.leading,
    this.trailing,
    this.initialExtended = false,
    this.config,
  });

  @override
  State<StatefulWidget> createState() => StateNavigationView();
}

class StateNavigationView extends State<NavigationView>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late bool extended;
  void pushName(String name) {
    setState(() {
      for (var element in widget.items.asMap().entries) {
        if (element.value.name == name) {
          _currentIndex = element.key;
        }
      }
    });
  }

  late AnimationController animationIconCtrl;
  @override
  void initState() {
    super.initState();
    extended = widget.initialExtended;
    animationIconCtrl = AnimationController(vsync: this)
      ..duration = Durations.medium4;
  }

  @override
  void dispose() {
    super.dispose();
    animationIconCtrl.dispose();
  }

  Widget buildRail() {
    var rail = widget.config;

    Widget? leading = widget.leading ??
        IconButton(
            onPressed: () => setState(() {
                  extended = !extended;
                  extended
                      ? animationIconCtrl.forward()
                      : animationIconCtrl.reverse();
                }),
            icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow, progress: animationIconCtrl));

    if (rail != null) {
      if (widget.leading == null &&
          !(rail.labelType == NavigationRailLabelType.none ||
              rail.labelType == null)) {
        leading = null;
      }
      return NavigationRail(
        key: rail.key,
        elevation: rail.elevation,
        extended: extended,
        indicatorColor: rail.indicatorColor,
        backgroundColor: rail.backgroundColor,
        indicatorShape: rail.indicatorShape,
        groupAlignment: rail.groupAlignment,
        minExtendedWidth: rail.minExtendedWidth,
        minWidth: rail.minWidth,
        useIndicator: rail.useIndicator,
        labelType: extended ? NavigationRailLabelType.none : rail.labelType,
        unselectedIconTheme: rail.unselectedIconTheme,
        unselectedLabelTextStyle: rail.unselectedLabelTextStyle,
        selectedLabelTextStyle: rail.selectedLabelTextStyle,
        selectedIconTheme: rail.selectedIconTheme,
        leading: leading,
        trailing: widget.trailing,
        destinations: widget.items,
        onDestinationSelected: (value) => setState(() {
          _currentIndex = value;
        }),
        selectedIndex: _currentIndex,
      );
    }
    return NavigationRail(
      leading: leading,
      extended: extended,
      trailing: widget.trailing,
      destinations: widget.items,
      labelType: NavigationRailLabelType.none,
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
          child: Padding(
            padding: widget.items[_currentIndex].pagePadding ??
                const EdgeInsets.all(12),
            child: AnimatedSwitcher(
                duration: widget.switchDuration ?? Durations.medium4,
                transitionBuilder: widget.transitionBuilder ??
                    (child, animation) =>
                        AnimatedSwitcher.defaultTransitionBuilder(
                            child, animation),
                child: widget.items[_currentIndex].page),
          ),
        ),
      ],
    );
  }
}

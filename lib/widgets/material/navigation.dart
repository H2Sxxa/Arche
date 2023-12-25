import 'package:flutter/material.dart';

class NavigationItem extends NavigationRailDestination {
  Widget page;
  String? name;
  NavigationItem({
    required super.icon,
    required super.label,
    required this.page,
    this.name,
  });
}

class NavigationView extends StatefulWidget {
  final List<NavigationItem> items;

  const NavigationView({
    super.key,
    required this.items,
  });

  @override
  State<StatefulWidget> createState() => _StateNavigationView();
}

class _StateNavigationView extends State<NavigationView> {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          destinations: widget.items,
          onDestinationSelected: (value) => setState(() {
            _currentIndex = value;
          }),
          selectedIndex: _currentIndex,
        ),
        //TODO May need animation here
        Expanded(child: widget.items[_currentIndex].page),
      ],
    );
  }
}

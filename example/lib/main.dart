import 'package:arche/arche.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugWrite("hello world");
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(
            body: NavigationView(
          items: [
            NavigationItem(
              icon: Icon(Icons.home),
              label: Text("Home"),
              page: Card(
                  child: Center(
                child: Text("Home"),
              )),
            ),
            NavigationItem(
              icon: Icon(Icons.settings),
              label: Text("Settings"),
              page: Center(
                child: Text("Settings"),
              ),
            ),
          ],
          config: NavigationRailConfig(
            labelType: NavigationRailLabelType.selected,
          ),
        )));
  }
}

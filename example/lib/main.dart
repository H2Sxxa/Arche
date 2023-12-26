import 'package:arche/widgets/material/navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
            body: NavigationView(
          items: [
            NavigationItem(
              icon: const Icon(Icons.home),
              label: const Text("Home"),
              page: const Card(
                  child: Center(
                child: Text("Home"),
              )),
            ),
            NavigationItem(
              icon: const Icon(Icons.settings),
              label: const Text("Settings"),
              page: const Center(
                child: Text("Settings"),
              ),
            ),
          ],
          config: const NavigationRailConfig(
            labelType: NavigationRailLabelType.selected,
          ),
        )));
  }
}

import 'package:arche/arche.dart';
import 'package:test/test.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(),
    );
  }
}

void main() {
  test("Test provider", () {
    ArcheBus().provide(ArcheConfig.memory());

    debugPrint((singleton.of<ArcheBus>()).getConfig.toString());
  });

  test("Provider to widget", () {
    runApp(TypeProvider().toWidget(const App()));
  });
}

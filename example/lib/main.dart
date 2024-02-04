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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: NavigationView.pageView(
          reversed: true,
          direction: Axis.horizontal,
          items: [
            NavigationItem(
              icon: const Icon(Icons.home),
              label: "Home",
              page: CardMenuButton(
                size: const Size.square(120),
                child: const Text("hello"),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text("hello"),
                    onTap: () => ComplexDialog(
                        child: const Dialog.fullscreen(
                      child: ProgressIndicatorWidget(),
                    )).prompt(context: context),
                  )
                ],
              ),
            ),
            NavigationItem(
              icon: const Icon(Icons.settings),
              label: "Settings",
              page: Center(
                child: ProgressIndicatorWidget(
                  onInit: (context, data, updateText, updateProgress) async {
                    for (var i = 0; i < 10; i++) {
                      debugWriteln(i);
                      updateProgress((i + 1) / 10);

                      await Future.delayed(const Duration(seconds: 1));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

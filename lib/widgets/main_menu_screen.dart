import 'package:flutter/material.dart';

class NumSelectorOptions extends InheritedWidget {
  final bool showNumSelector;
  final ValueChanged<bool> onToggle;

  const NumSelectorOptions({
    super.key,
    required this.showNumSelector,
    required this.onToggle,
    required Widget child,
  }) : super(child: child);

  static NumSelectorOptions? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NumSelectorOptions>();
  }

  @override
  bool updateShouldNotify(NumSelectorOptions oldWidget) =>
      showNumSelector != oldWidget.showNumSelector;
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/game'),
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/options'),
              child: const Text('Options'),
            ),
          ],
        ),
      ),
    );
  }
}

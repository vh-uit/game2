import 'package:flutter/material.dart';
import 'package:game2/widgets/main_menu_screen.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  void _restartGame(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/game');
  }

  @override
  Widget build(BuildContext context) {
    final options = NumSelectorOptions.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Options')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Show Number Selector'),
                Switch(
                  value: options?.showNumSelector ?? true,
                  onChanged: options?.onToggle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _restartGame(context),
              child: const Text('Restart Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Quit Game'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

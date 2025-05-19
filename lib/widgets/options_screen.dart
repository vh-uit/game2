import 'package:flutter/material.dart';

enum NumSelectorMode { none, single, double }

class OptionsScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onRestart;
  final VoidCallback? onQuit;
  final NumSelectorMode numSelectorMode;
  final ValueChanged<NumSelectorMode>? onModeChanged;

  const OptionsScreen({
    super.key,
    this.onBack,
    this.onRestart,
    this.onQuit,
    this.numSelectorMode = NumSelectorMode.single,
    this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Options')),
      body: Center(
        child: _OptionsBody(
          onBack: onBack,
          onRestart: onRestart,
          onQuit: onQuit,
          numSelectorMode: numSelectorMode,
          onModeChanged: onModeChanged,
        ),
      ),
    );
  }
}

class _OptionsBody extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onRestart;
  final VoidCallback? onQuit;
  final NumSelectorMode numSelectorMode;
  final ValueChanged<NumSelectorMode>? onModeChanged;
  const _OptionsBody({
    this.onBack,
    this.onRestart,
    this.onQuit,
    this.numSelectorMode = NumSelectorMode.single,
    this.onModeChanged,
  });

  @override
  State<_OptionsBody> createState() => _OptionsBodyState();
}

class _OptionsBodyState extends State<_OptionsBody> {
  late NumSelectorMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.numSelectorMode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Num Selector Mode'),
            const SizedBox(width: 16),
            DropdownButton<NumSelectorMode>(
              value: _mode,
              items: const [
                DropdownMenuItem(
                  value: NumSelectorMode.none,
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: NumSelectorMode.single,
                  child: Text('Single'),
                ),
                DropdownMenuItem(
                  value: NumSelectorMode.double,
                  child: Text('Double'),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _mode = val;
                  });
                  if (widget.onModeChanged != null) {
                    widget.onModeChanged!(val);
                  }
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.onRestart,
          child: const Text('Restart Game'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.onQuit,
          child: const Text('Quit Game'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: widget.onBack,
          child: const Text('Back'),
        ),
      ],
    );
  }
}

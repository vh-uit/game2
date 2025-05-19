import 'package:flutter/material.dart';

enum NumSelectorMode { none, single, double }

class OptionsScreen extends StatefulWidget {
  final VoidCallback? onQuit;
  final VoidCallback? onRestart;
  final NumSelectorMode numSelectorMode;
  final ValueChanged<NumSelectorMode>? onModeChanged;
  final VoidCallback? onBack;

  const OptionsScreen({
    super.key,
    this.onQuit,
    this.onRestart,
    required this.numSelectorMode,
    this.onModeChanged,
    this.onBack,
  });

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  late NumSelectorMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.numSelectorMode;
  }

  void _onModeChanged(NumSelectorMode mode) {
    setState(() {
      _selectedMode = mode;
    });
    if (widget.onModeChanged != null) {
      widget.onModeChanged!(mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Options', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.menu),
                label: const Text('Quit to Menu'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: widget.onQuit,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Restart Game'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                onPressed: widget.onRestart,
              ),
              const SizedBox(height: 24),
              const Text('Number Selector Mode', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              SegmentedButton<NumSelectorMode>(
                segments: const [
                  ButtonSegment(
                    value: NumSelectorMode.single,
                    label: Text('Single'),
                    icon: Icon(Icons.looks_one),
                  ),
                  ButtonSegment(
                    value: NumSelectorMode.double,
                    label: Text('Double'),
                    icon: Icon(Icons.looks_two),
                  ),
                  ButtonSegment(
                    value: NumSelectorMode.none,
                    label: Text('None'),
                    icon: Icon(Icons.block),
                  ),
                ],
                selected: <NumSelectorMode>{_selectedMode},
                onSelectionChanged: (Set<NumSelectorMode> newSelection) {
                  if (newSelection.isNotEmpty) {
                    _onModeChanged(newSelection.first);
                  }
                },
                showSelectedIcon: false,
              ),
              const SizedBox(height: 24),
              if (widget.onBack != null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                  onPressed: widget.onBack,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

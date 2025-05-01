import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.content,
    required this.isSelected,
    required this.onTap,
    required this.isHighlighted,
  });

  final int content;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double scaleFactor = isHighlighted ? 1.1 : 1.0;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color:
              isHighlighted
                  ? Colors.yellowAccent.withValues(alpha: 0.7)
                  : isSelected
                  ? Colors.blueAccent
                  : Colors.white,
        ),
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..scale(scaleFactor),
        child: Center(
          child: Text(
            content == 0 ? "" : content.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

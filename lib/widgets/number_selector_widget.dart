import 'package:flutter/material.dart';

typedef NumberSelectedCallback = void Function(int number);

class NumSelectorWidget extends StatelessWidget {
  final NumberSelectedCallback onNumberSelected;
  final double buttonSize;
  final double spacing;
  final double borderRadius;
  final double fontSize;

  const NumSelectorWidget({
    super.key,
    required this.onNumberSelected,
    required this.buttonSize,
    required this.spacing,
    required this.borderRadius,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    // 0-9 in a single row
    final numbers = List.generate(10, (i) => i);

    return IgnorePointer(
      ignoring: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 48, // 24 padding each side
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [Colors.amber[100]!, Colors.amber[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.3),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: numbers
                          .map(
                            (numberValue) => Padding(
                              padding: EdgeInsets.only(
                                right: numberValue != numbers.last ? spacing : 0,
                              ),
                              child: SizedBox(
                                width: buttonSize,
                                height: buttonSize,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(borderRadius + 12),
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.brown[900],
                                    elevation: 6,
                                    shadowColor: Colors.amber[200],
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () => onNumberSelected(numberValue),
                                  child: Center(
                                    child: Text(
                                      '$numberValue',
                                      style: TextStyle(
                                        fontSize: fontSize + 4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown[900],
                                        letterSpacing: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

typedef NumberSelectedCallback = void Function(int number);

class NumSelectorWidget extends StatelessWidget {
  final NumberSelectedCallback onNumberSelected;
  final double buttonSize;
  final double spacing;
  final double borderRadius;
  final double fontSize;
  final bool bottomAlignment;

  const NumSelectorWidget({
    super.key,
    required this.onNumberSelected,
    required this.buttonSize,
    required this.spacing,
    required this.borderRadius,
    required this.fontSize,
    this.bottomAlignment = true,
  });

  @override
  Widget build(BuildContext context) {
    // 0-9 in a single row
    final numbers = List.generate(10, (i) => i);

    return IgnorePointer(
      ignoring: false,
      child: Align(
        alignment: bottomAlignment ? Alignment.bottomCenter : Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    numbers
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
                                    borderRadius: BorderRadius.circular(
                                      borderRadius,
                                    ),
                                  ),
                                  backgroundColor: Colors.amber[200],
                                  foregroundColor: Colors.brown[900],
                                  elevation: 2,
                                ),
                                onPressed: () => onNumberSelected(numberValue),
                                child: Text(
                                  '$numberValue',
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
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
    );
  }
}

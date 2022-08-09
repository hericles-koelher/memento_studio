import 'package:flutter/material.dart';

import '../utils/constants.dart';

class MSButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  const MSButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: -2,
            offset: Offset(4, 3),
          )
        ],
      ),
      child: ElevatedButton(
        style: style,
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}

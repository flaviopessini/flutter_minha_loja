import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const BadgeWidget({
    required this.child,
    required this.value,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color ?? Theme.of(context).colorScheme.primaryVariant,
            ),
            padding: const EdgeInsets.all(2.0),
            constraints: const BoxConstraints(
              minHeight: 16.0,
              minWidth: 16.0,
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

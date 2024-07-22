import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final void Function()? onTap;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.only(
            top: 25,
            bottom: 25,
            right: 50,
            left: 50,
          ),
        ),
      ),
      onPressed: onTap,
      child: Text(
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
        ),
        label,
      ),
    );
  }
}

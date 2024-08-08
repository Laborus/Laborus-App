import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String routeName;
  const CustomIconButton(
      {super.key, required this.icon, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Icon(icon),
      ),
    );
  }
}

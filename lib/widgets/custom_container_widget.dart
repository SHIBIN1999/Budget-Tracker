import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;

  const CustomContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: const Offset(0, 3), // Offset in the Y direction
          ),
        ],
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.lightBlue,
      child: const Center(
        child: Text(
          'Custom Widget',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

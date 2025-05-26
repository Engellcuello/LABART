import 'package:flutter/material.dart';
import '../../../../common/widgets/custom_Shapes/containers/pimary_header_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
                child: Column(
                    children: [
                      
                    ],
                )
            )
          ],
        ),
      ),
    );
  }
}



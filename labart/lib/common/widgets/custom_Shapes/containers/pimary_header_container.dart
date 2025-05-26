

import 'package:flutter/material.dart';

import '../curved_edges/curved_edges_widget.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget( 
      child: SizedBox(
        height: 1000,

        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          //Theme.of(context).scaffoldBackgroundColor


          child: Stack(
            children: [
              child
            ],
          ),
        )

        
      ),
    );
  }
}
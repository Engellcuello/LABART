import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final int itemCount;

  const ShimmerPlaceholder({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return _ShimmerCard(index: index);
        },
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final int index;

  const _ShimmerCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random(index); // semilla estable para que no cambie cada frame
    final height = 150 + random.nextInt(100); // altura entre 150 y 250

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: height.toDouble(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

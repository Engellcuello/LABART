import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ExploreImageCard extends StatefulWidget {
  final List<String> imageUrls;
  final String title;
  final String subtitle;
  final String totalReactions; // Changed from peopleCount to totalReactions
  final String totalComments; // Added for comments count
  final String userName;
  final String? userImage;
  final String daysAgo;

  const ExploreImageCard({
    super.key,
    required this.imageUrls,
    required this.title,
    required this.subtitle,
    required this.totalReactions,
    required this.totalComments,
    required this.userName,
    required this.userImage,
    required this.daysAgo,
  });

  @override
  _ExploreImageCardState createState() => _ExploreImageCardState();
}

class _ExploreImageCardState extends State<ExploreImageCard> {
  final PageController _pageController = PageController();
  final double _gradientHeight = 150; // Altura del gradiente

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int page) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenedor de imágenes con PageView
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
            width: double.infinity,
            height: 600,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: _handlePageChanged,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 600,
                    ),
                    // Gradiente movido dentro del PageView
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: _gradientHeight,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.80),
                                Colors.black.withOpacity(0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          top: TSizes.lg,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.imageUrls.length, // Now shows actual number of images
              effect: ScaleEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white54,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ),
        Positioned(
          top: TSizes.lg * 2,
          left: TSizes.lg,
          child: _buildUserInfo(),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                    child: Row(
                      children: [
                        _buildTransparentButton(Iconsax.heart_copy, widget.totalReactions),
                        const SizedBox(width: 8),
                        _buildTransparentButton(Iconsax.message_copy, widget.totalComments),
                        const SizedBox(width: 8),
                        _buildTransparentButton(Icons.redo, ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: TSizes.md),
                    child: _buildPeopleCount(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: TSizes.sm,
          ),
          decoration: BoxDecoration(
            color: TColors.darkContainer.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              // Avatar modificado para manejar imagen nula
              widget.userImage != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.userImage!),
                      radius: 20,
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[800],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
              const SizedBox(width: TSizes.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.daysAgo,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeopleCount() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md,
            vertical: TSizes.sm,
          ),
          decoration: BoxDecoration(
            color: TColors.darkContainer.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.people, size: 19, color: Colors.white),
              const SizedBox(width: TSizes.xs),
              Text(
                '1.2k', // Fixed number for now
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransparentButton(IconData icon, String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              if (text.isNotEmpty) const SizedBox(width: 4),
              if (text.isNotEmpty)
                Text(
                  text,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
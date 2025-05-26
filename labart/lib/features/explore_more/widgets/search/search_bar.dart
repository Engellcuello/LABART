import 'package:flutter/material.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';

class ExploreSearchBar extends StatelessWidget {
  const ExploreSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TSizes.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(
            color: TColors.textSecondary,
            fontSize: TSizes.fontSizeMd,
          ),
          prefixIcon: const Icon(Icons.search_rounded, 
              size: TSizes.iconMd, 
              color: TColors.textSecondary),
          filled: true,
          fillColor: TColors.lightContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.borderRadiusXl),
            borderSide: const BorderSide(color: TColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: TSizes.md,
          ),
        ),
      ),
    );
  }
}
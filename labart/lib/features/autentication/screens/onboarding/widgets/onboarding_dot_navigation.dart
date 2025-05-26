
import 'package:flutter/material.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:labart/utils/device/device_utility.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/features/autentication/screens/onboarding/controllers.onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance ;
    final dark = THelperFunctions.isDarkMode(context);
    
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,

      child: SmoothPageIndicator(
        count:4,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(activeDotColor: dark ? TColors.light : TColors.dark, dotHeight: 6),
      ),
    );
  }
}
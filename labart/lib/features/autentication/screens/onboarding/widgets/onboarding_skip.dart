
import 'package:flutter/material.dart';
import 'package:labart/utils/device/device_utility.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/features/autentication/screens/onboarding/controllers.onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getAppBarHeight(),
        right: TSizes.defaultSpace,
        child: TextButton(onPressed: () =>OnBoardingController.instance.skipPage(),
            child: const Text('Skip')
        )
    );
  }
}
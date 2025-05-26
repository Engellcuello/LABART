import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/features/autentication/screens/onboarding/controllers.onboarding/onboarding_controller.dart';
import 'package:labart/utils/constants/image_strings.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/features/autentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:labart/features/autentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:labart/features/autentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:labart/features/autentication/screens/onboarding/widgets/onboarding_next_buttom.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = Get.put(OnBoardingController());
  final List<Widget> _cachedPages = [];

  @override
  void initState() {
    super.initState();
    // Precargamos todas las páginas al iniciar
    _cachedPages.addAll([
      const OnBoardingPage(
        image: TImages.onBoardinImage1,
        title: TTexts.onBoardingTitle1,
        subTitle: TTexts.onBoardingSubTitle1,
      ),
      const OnBoardingPage(
        image: TImages.onBoardinImage2,
        title: TTexts.onBoardingTitle2,
        subTitle: TTexts.onBoardingSubTitle2,
      ),
      const OnBoardingPage(
        image: TImages.onBoardinImage3,
        title: TTexts.onBoardingTitle3,
        subTitle: TTexts.onBoardingSubTitle3,
      ),
      const OnBoardingPage(
        image: TImages.onBoardinImage4,
        title: TTexts.onBoardingTitle4,
        subTitle: TTexts.onBoardingSubTitle4,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            physics: const PageScrollPhysics(),
            itemCount: _cachedPages.length,
            itemBuilder: (context, index) => _cachedPages[index],
          ),
          const OnBoardingSkip(),
          const OnBoardingDotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<OnBoardingController>(); // Limpia el controlador
    super.dispose();
  }
}
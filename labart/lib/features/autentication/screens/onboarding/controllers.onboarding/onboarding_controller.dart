import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // Clave para las preferencias
  static String get onboardingKey => _onboardingKey;
  static const String _onboardingKey = 'onboarding_completed_v4';
  
  final PageController pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  final _transitionDuration = const Duration(milliseconds: 800);

  // Método para navegación con dots
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.animateToPage(
      index,
      duration: _transitionDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  void nextPage() {
    if (currentPageIndex.value == 3) {
      _completeOnboarding().then((_) {
        Get.offAll(() => const AuthScreen());
      });
    } else {
      int nextPage = currentPageIndex.value + 1;
      pageController.animateToPage(
        nextPage,
        duration: _transitionDuration,
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void skipPage() {
    _completeOnboarding().then((_) {
      Get.offAll(() => const AuthScreen());
    });
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
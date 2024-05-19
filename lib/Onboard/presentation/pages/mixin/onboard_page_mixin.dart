import 'package:flutter/material.dart';
import 'package:labeling/Onboard/presentation/pages/onboard_view.dart';

/// [OnBoardPageMixin] is a mixin that provides common functionality for managing
/// the state and page controller in an onboarding page.
mixin OnBoardPageMixin<T extends StatefulWidget> on State<OnBoardingPageView> {
  late PageController pageController;
  late bool isDark;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

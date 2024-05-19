import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labeling/Onboard/presentation/cubit/onboard_cubit.dart';
import 'package:labeling/Onboard/presentation/pages/mixin/onboard_page_mixin.dart';

import 'package:labeling/Onboard/presentation/widgets/page_content_list.dart';
import 'package:labeling/extension/padding.dart';
import 'package:labeling/style/material3_desing_constant.dart';

/// [OnBoardingPageView] is the main widget for the onboarding pages.
class OnBoardingPageView extends StatefulWidget {
  const OnBoardingPageView({super.key});

  @override
  State<OnBoardingPageView> createState() => _OnBoardingPageViewState();
}

class _OnBoardingPageViewState extends State<OnBoardingPageView>
    with OnBoardPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: onBoardingContentsList.length,
                  controller: pageController,
                  onPageChanged: (int index) {
                    context.read<OnBoardCubit>().onBoardIndexChangeState(index);
                  },
                  itemBuilder: (context, index) {
                    return buildPageContent(index);
                  },
                ),
              ),

              // Skip button at the top right
              Align(
                alignment: Alignment.topRight,
                child: buildSkipButton(context),
              ).padded(const EdgeInsets.only(top: 20, right: 10)),
              // Centered image above the text

              // Dots row and Next button at the bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomButtons(),
              ).padded(const EdgeInsets.only(bottom: 40))
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the content of a single onboarding page.
  Widget buildPageContent(int index) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/${index + 1}.png",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        index == 0
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: onBoardingContentsList[index].color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    onBoardingContentsList[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: onBoardingContentsList[index].colorText,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : const SizedBox(),

        index >= 2
            ? Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: MediaQuery.of(context).size.height * 0.35),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: onBoardingContentsList[index].color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            onBoardingContentsList[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingContentsList[index].colorText,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: onBoardingContentsList[index].color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            onBoardingContentsList[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: onBoardingContentsList[index].colorText,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
              )
            : const SizedBox(),
        // Text(
        //   onBoardingContentsList[index].title,
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context)
        //       .textTheme
        //       .headlineLarge!
        //       .copyWith(fontWeight: FontWeight.bold),
        // ).paddedSymmetric(horizontal: Material3Design.mediumPagePadding),
        // const SizedBox(height: Material3Design.mediumPagePadding),
        // Text(
        //   onBoardingContentsList[index].description,
        //   textAlign: TextAlign.center,
        // ).paddedSymmetric(horizontal: Material3Design.mediumPagePadding),
      ],
    );
    // .padded(const EdgeInsets.only(top: 40));
  }

  /// Builds the bottom buttons section including dots and navigation buttons.
  Widget buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dots row
        buildDotsRow(context),
        // Next button
        buildNextButton(),
      ],
    ).paddedSymmetric(horizontal: Material3Design.largePadding).padded(
          const EdgeInsets.only(top: 60),
        );
  }

  /// Builds the "Skip" button.
  CupertinoButton buildSkipButton(BuildContext context) {
    return CupertinoButton(
      child: const Text(
        "Atla",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        BlocProvider.of<OnBoardCubit>(context).onBoardFinishedChangeState(true);
      },
    );
  }

  /// Builds the row of dots indicating the current onboarding page.
  Row buildDotsRow(BuildContext context) {
    return Row(
      children: List.generate(
        onBoardingContentsList.length,
        (index) => BlocBuilder<OnBoardCubit, OnBoardState>(
          buildWhen: (previous, current) => previous.index != current.index,
          builder: (context, state) {
            return buildDot(index, state.index, context);
          },
        ),
      ),
    );
  }

  /// Builds a single dot in the dots row.
  AnimatedContainer buildDot(
      int index, int currentIndex, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: (currentIndex == index
            ? onBoardingContentsList[index].color
            : onBoardingContentsList[currentIndex].color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  /// Builds the "Next" button with a progress indicator.
  CupertinoButton buildNextButton() {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: BlocBuilder<OnBoardCubit, OnBoardState>(
              buildWhen: (previous, current) =>
                  previous.percentage != current.percentage,
              builder: (context, state) {
                return CircularProgressIndicator(
                  value: state.percentage,
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      onBoardingContentsList[state.index].color),
                  backgroundColor: Colors.white,
                );
              },
            ),
          ),
          BlocBuilder<OnBoardCubit, OnBoardState>(
              buildWhen: (previous, current) =>
                  previous.percentage != current.percentage,
              builder: (context, state) {
                return CircleAvatar(
                  backgroundColor: onBoardingContentsList[state.index].color,
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: onBoardingContentsList[state.index].colorText,
                  ),
                );
              })
        ],
      ),
      onPressed: () {
        if (context.read<OnBoardCubit>().state.index ==
            onBoardingContentsList.length - 1) {
          context.read<OnBoardCubit>().onBoardFinishedChangeState(true);
        }
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}

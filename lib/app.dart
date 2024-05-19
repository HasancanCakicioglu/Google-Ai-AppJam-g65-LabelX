import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labeling/Onboard/presentation/cubit/onboard_cubit.dart';
import 'package:labeling/Onboard/presentation/pages/onboard_view.dart';
import 'package:labeling/auth/login_view.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<OnBoardCubit, OnBoardState>(
      buildWhen: (previous, current) => previous.finished != current.finished,
      builder: (context, onBoardState) {
        if (onBoardState.finished) {
          return SignInScreen();
        } else {
          return const OnBoardingPageView();
        }
      },
    ));
  }
}

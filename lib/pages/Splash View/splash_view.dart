import 'dart:async';

import 'package:daily_expense/pages/Home%20View/home_view.dart';
import 'package:daily_expense/pages/Splash%20View/splash_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onViewModelReady: (viewModel) {
        Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          )),
        );
      },
      builder: (context, viewModel, child) {
        return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 2,
                child: Image.asset('assets/icon.png'),
              ),
            ));
      },
    );
  }
}

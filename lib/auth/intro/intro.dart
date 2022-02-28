import 'package:flutter/material.dart';
import 'package:pulsar/auth/intro/final_slide.dart';
import 'package:pulsar/auth/intro/intro_slide.dart';
import 'package:pulsar/auth/intro/second_slide.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  skip() {
    pageController.jumpToPage(2);
  }

  next() {
    pageController.jumpToPage(index + 1);
  }

  toPage(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (page) => setState(() => index = page),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          IntroSlide(
            index: index,
            onSkip: skip,
            onNext: next,
            toPage: toPage,
          ),
          SecondSlide(
            index: index,
            onSkip: skip,
            onNext: next,
            toPage: toPage,
          ),
          FinalSlide(
            index: index,
            toPage: toPage,
          ),
        ],
      ),
    );
  }
}

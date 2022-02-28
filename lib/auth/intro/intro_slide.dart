import 'package:flutter/material.dart';
import 'package:pulsar/auth/intro/slide_template.dart';

class IntroSlide extends StatefulWidget {
  final int index;
  final Function() onSkip;
  final Function() onNext;
  final Function(int page) toPage;
  const IntroSlide(
      {required this.index,
      required this.onNext,
      required this.onSkip,
      required this.toPage,
      Key? key})
      : super(key: key);

  @override
  _IntroSlideState createState() => _IntroSlideState();
}

class _IntroSlideState extends State<IntroSlide> {
  @override
  Widget build(BuildContext context) {
    return SlideTemplate(
      illustration: 'assets/illustrations/art.svg',
      description:
          'Share you skills and talents with the world. Build a community around the people who share your interests.',
      index: widget.index,
      onSkip: widget.onSkip,
      onNext: widget.onNext,
      toPage: widget.toPage,
    );
  }
}

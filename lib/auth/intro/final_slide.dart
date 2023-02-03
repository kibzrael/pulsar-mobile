import 'package:flutter/material.dart';
import 'package:pulsar/auth/intro/slide_template.dart';

class FinalSlide extends StatefulWidget {
  final int index;
  final Function() onSkip;
  final Function() onNext;
  final Function(int page) toPage;
  const FinalSlide(
      {required this.index,
      required this.toPage,
      required this.onNext,
      required this.onSkip,
      Key? key})
      : super(key: key);

  @override
  State<FinalSlide> createState() => _FinalSlideState();
}

class _FinalSlideState extends State<FinalSlide> {
  @override
  Widget build(BuildContext context) {
    return SlideTemplate(
      illustration: 'assets/illustrations/karaoke.svg',
      title:
          'Join Challenges to earn points and win prizes.', // const PulsarTextLogo(),
      description:
          'Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
      index: widget.index,
      onSkip: widget.onSkip,
      onNext: widget.onNext,
      toPage: widget.toPage,
    );
  }
}

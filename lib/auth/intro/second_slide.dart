import 'package:flutter/material.dart';
import 'package:pulsar/auth/intro/slide_template.dart';
import 'package:pulsar/providers/localization_provider.dart';

class SecondSlide extends StatefulWidget {
  final int index;
  final Function() onSkip;
  final Function() onNext;
  final Function(int page) toPage;
  const SecondSlide(
      {required this.index,
      required this.onNext,
      required this.onSkip,
      required this.toPage,
      Key? key})
      : super(key: key);

  @override
  State<SecondSlide> createState() => _SecondSlideState();
}

class _SecondSlideState extends State<SecondSlide> {
  @override
  Widget build(BuildContext context) {
    return SlideTemplate(
      illustration: 'assets/illustrations/art.svg',
      title: local(context).introTitle2,
      description:
          'Lorem Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
      index: widget.index,
      onSkip: widget.onSkip,
      onNext: widget.onNext,
      toPage: widget.toPage,
    );
  }
}

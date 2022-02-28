import 'package:flutter/material.dart';
import 'package:pulsar/auth/intro/slide_template.dart';

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
  _SecondSlideState createState() => _SecondSlideState();
}

class _SecondSlideState extends State<SecondSlide> {
  @override
  Widget build(BuildContext context) {
    return SlideTemplate(
      illustration: 'assets/illustrations/karaoke.svg',
      description:
          'Participate in challenges to earn points and win prizes. Put your skills into great use',
      index: widget.index,
      onSkip: widget.onSkip,
      onNext: widget.onNext,
      toPage: widget.toPage,
    );
  }
}

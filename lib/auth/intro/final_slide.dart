import 'package:flutter/material.dart';
import 'package:pulsar/auth/auth.dart';
import 'package:pulsar/auth/intro/slide_template.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';

class FinalSlide extends StatefulWidget {
  final int index;
  final Function(int page) toPage;
  const FinalSlide({required this.index, required this.toPage, Key? key})
      : super(key: key);

  @override
  _FinalSlideState createState() => _FinalSlideState();
}

class _FinalSlideState extends State<FinalSlide> {
  @override
  Widget build(BuildContext context) {
    return SlideTemplate(
      illustration: 'assets/illustrations/intro.svg',
      title: const PulsarTextLogo(),
      description: 'Express your play',
      style: const TextStyle(fontSize: 21, fontStyle: FontStyle.italic),
      index: widget.index,
      toPage: widget.toPage,
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: AuthButton(
            title: 'Get Started',
            onPressed: () {
              Navigator.of(context).pushReplacement(myPageRoute(
                builder: (context) => const AuthScreen(
                  initialPage: 1,
                ),
              ));
            }),
      ),
    );
  }
}

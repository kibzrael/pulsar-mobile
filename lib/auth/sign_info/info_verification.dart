import 'package:flutter/material.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/auth/verify_code.dart';
import 'package:pulsar/widgets/route.dart';

class InfoVerification extends StatefulWidget {
  final SignupInfo info;

  InfoVerification({required this.info});

  @override
  _InfoVerificationState createState() => _InfoVerificationState();
}

class _InfoVerificationState extends State<InfoVerification> {
  @override
  Widget build(BuildContext context) {
    return VerifyCode(
      info: widget.info,
      onBack: () {
        Navigator.pop(context);
      },
      onDone: () {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            myPageRoute(builder: (context) => SignInfo(widget.info)));
      },
    );
  }
}

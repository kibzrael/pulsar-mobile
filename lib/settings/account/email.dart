import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/verify_code.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/user_provider.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    sendCode();
  }

  sendCode() async {}

  verify(String code) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VerifyCode(
          account: user.email ?? user.phone ?? '',
          verify: verify,
          onDone: () {},
          onBack: () {
            Navigator.pop(context);
          },
          resend: sendCode),
    );
  }
}

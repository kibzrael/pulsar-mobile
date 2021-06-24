import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/birthday.dart';
import 'package:pulsar/auth/sign_info/category.dart';
import 'package:pulsar/auth/sign_info/interests.dart';
import 'package:pulsar/auth/sign_info/log_credentials.dart';
import 'package:pulsar/auth/sign_info/profile_photo.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';

class SignInfo extends StatefulWidget {
  @override
  _SignInfoState createState() => _SignInfoState();
}

class _SignInfoState extends State<SignInfo> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SignInfoProvider(),
        builder: (context, snapshot) {
          return Consumer<SignInfoProvider>(
              builder: (context, provider, child) {
            return Scaffold(
              body: PageView(
                  controller: provider.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    LogCredentials(),
                    BirthdayPage(),
                    ChooseCategory(),
                    ProfilePhoto(),
                    InterestsPage(),
                  ]),
            );
          });
        });
  }
}

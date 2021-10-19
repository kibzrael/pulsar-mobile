import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/birthday.dart';
import 'package:pulsar/auth/sign_info/category.dart';
import 'package:pulsar/auth/sign_info/interests.dart';
import 'package:pulsar/auth/sign_info/introduce_yourself.dart';
import 'package:pulsar/auth/sign_info/log_credentials.dart';
import 'package:pulsar/auth/sign_info/profile_photo.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/classes/icons.dart';

class SignInfo extends StatelessWidget {
  final SignupInfo info;

  SignInfo(this.info);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SignInfoProvider(info),
        builder: (context, snapshot) {
          return Consumer<SignInfoProvider>(
              builder: (context, provider, child) {
            return Scaffold(
              body: PageView(
                  controller: provider.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    LogCredentials(),
                    IntroduceYourself(),
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

class SignInfoBackButton extends StatelessWidget {
  final void Function() onPressed;

  SignInfoBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).inputDecorationTheme.fillColor),
        child: Icon(
          MyIcons.back,
        ),
      ),
    );
  }
}

class SignInfoForwardButton extends StatelessWidget {
  final void Function() onPressed;

  SignInfoForwardButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 4, 0, 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryVariant
            ])),
        child: Icon(
          MyIcons.forward,
        ),
      ),
    );
  }
}

class SignInfoTitle extends StatelessWidget {
  final String title;
  final Function() onBack;
  final Function() onForward;

  SignInfoTitle(
      {required this.title, required this.onBack, required this.onForward});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SignInfoBackButton(onPressed: onBack),
            Text(title),
            SignInfoForwardButton(onPressed: onForward),
          ],
        ));
  }
}

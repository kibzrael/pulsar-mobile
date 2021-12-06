import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/birthday.dart';
import 'package:pulsar/auth/sign_info/category.dart';
import 'package:pulsar/auth/sign_info/interests.dart';
import 'package:pulsar/auth/sign_info/introduce_yourself.dart';
import 'package:pulsar/auth/sign_info/profile_photo.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/text_button.dart';

class SignInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignInfoProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: PageView(
            controller: provider.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              IntroduceYourself(),
              ChooseCategory(),
              BirthdayPage(),
              ProfilePhoto(),
              InterestsPage(),
            ]),
      );
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
        margin: EdgeInsets.only(
          left: 12,
        ),
        height: kToolbarHeight,
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Theme.of(context).inputDecorationTheme.fillColor),
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
        height: kToolbarHeight,
        padding: EdgeInsets.only(right: 15),
        alignment: Alignment.center,
        child: ShaderMask(
          shaderCallback: (bounds) => primaryGradient().createShader(bounds),
          child: Text(
            'Next',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
            // Container(
            //   margin: EdgeInsets.fromLTRB(4, 4, 0, 4),
            //   padding: EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       gradient: LinearGradient(colors: [
            //         Theme.of(context).colorScheme.primary,
            //         Theme.of(context).colorScheme.primaryVariant
            //       ])),
            //   child: Icon(
            //     MyIcons.forward,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}

AppBar signInfoAppBar(
    {required String title,
    required Function() onBack,
    required Function() onForward}) {
  return AppBar(
    leading: IconButton(icon: Icon(MyIcons.back), onPressed: onBack),
    title: Text(title),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: 12),
        child: MyTextButton(text: 'Next', onPressed: onForward),
      ),
    ],
  );
}

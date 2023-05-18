import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/auth.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/settings/policies/privacy_policy.dart';
import 'package:pulsar/settings/policies/terms_of_use.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/divider.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';

class IntroAuth extends StatefulWidget {
  const IntroAuth({Key? key}) : super(key: key);

  @override
  State<IntroAuth> createState() => _IntroAuthState();
}

class _IntroAuthState extends State<IntroAuth> {
  late TapGestureRecognizer privacyPolicyRecognizer;
  late TapGestureRecognizer termsOfUseRecognizer;

  @override
  void initState() {
    super.initState();
    privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => const PrivacyPolicy()));
      };
    termsOfUseRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context)
            .push(myPageRoute(builder: (context) => const TermsOfUse()));
      };
  }

  @override
  void dispose() {
    privacyPolicyRecognizer.dispose();
    termsOfUseRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor?.withOpacity(0.0),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const PulsarLogo(size: 150),
            const PulsarTextLogo(),
            Text('Express Your Play',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
            const Spacer(flex: 2),
            LinkedAccountLogin(provider,
                divider: false, text: local(context).continueWith),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: MyDivider(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ActionButton(
                title:
                    '${local(context).continueWith} ${local(context).email}/${local(context).phone}',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      myPageRoute(
                        builder: (context) => const AuthScreen(
                          initialPage: 1,
                        ),
                      ),
                      (route) => false);
                },
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: '${local(context).policyAgreement} ',
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        TextSpan(
                            text: local(context).privacyPolicy,
                            recognizer: privacyPolicyRecognizer,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline)),
                        TextSpan(text: ' ${local(context).and} '),
                        TextSpan(
                            text: '${local(context).termsOfUse}.',
                            recognizer: termsOfUseRecognizer,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline))
                      ])),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

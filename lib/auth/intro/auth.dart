import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/auth.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/providers/login_provider.dart';
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
                style: Theme.of(context).textTheme.headline1?.copyWith(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
            const Spacer(flex: 2),
            LinkedAccountLogin(provider, divider: false, text: 'Continue'),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: MyDivider(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ActionButton(
                title: 'Continue with Email/Phone',
                onPressed: () {
                  Navigator.of(context).pushReplacement(myPageRoute(
                    builder: (context) => const AuthScreen(
                      initialPage: 1,
                    ),
                  ));
                },
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By joining you agree to our ',
                      style: Theme.of(context).textTheme.subtitle2,
                      children: [
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline)),
                        const TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Terms of Use.',
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

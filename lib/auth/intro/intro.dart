import 'package:flutter/material.dart';
import 'package:pulsar/auth/auth.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => RootIntroPage(),
          settings: settings,
        );
      },
    );
  }
}

class RootIntroPage extends StatefulWidget {
  @override
  _RootIntroPageState createState() => _RootIntroPageState();
}

class _RootIntroPageState extends State<RootIntroPage> {
  void toRegister() {
    Navigator.of(context).pushReplacement(myPageRoute(
      builder: (context) => AuthScreen(
        initialPage: 1,
      ),
    ));
  }

  void toLogin() {
    Navigator.of(context).pushReplacement(myPageRoute(
        builder: (context) => AuthScreen(
              initialPage: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              height: constraints.maxHeight,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PulsarLogo(size: MediaQuery.of(context).size.width / 2),
                    SizedBox(height: 30),
                    PulsarTextLogo(),
                    SizedBox(height: 30),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(children: [
                          ActionButton(
                            title: 'Register',
                            onPressed: toRegister,
                          ),
                          SizedBox(height: 15),
                          ActionButton(
                            title: 'Login',
                            backgroundColor: Theme.of(context).disabledColor,
                            titleColor:
                                Theme.of(context).textTheme.bodyText2!.color,
                            onPressed: toLogin,
                          )
                        ]))
                  ]),
            ),
          );
        }),
      ),
    );
  }
}

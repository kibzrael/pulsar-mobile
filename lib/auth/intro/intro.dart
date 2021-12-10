import 'package:flutter/material.dart';
import 'package:pulsar/auth/auth.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/theme_provider.dart';
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
  bool agreed = false;

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
    double topPadding = MediaQuery.of(context).padding.top;

    return Theme(
      data: darkTheme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/intro.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: topPadding + kToolbarHeight),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              MyIcons.menu,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    PulsarLogo(size: MediaQuery.of(context).size.width / 2.4),
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
                            backgroundColor: Colors.white,
                            titleColor: lightTheme.textTheme.bodyText2!.color,
                            onPressed: toLogin,
                          )
                        ])),
                    LinkedAccountLogin(
                      color: Colors.white,
                      dividerColor: Colors.white54,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: agreed,
                            onChanged: (value) {
                              setState(() {
                                agreed = value ?? true;
                              });
                            },
                          ),
                          Flexible(
                            child: RichText(
                              text:
                                  TextSpan(text: 'I agree to the ', children: [
                                WidgetSpan(
                                    child: ShaderMask(
                                        shaderCallback: (rect) {
                                          return LinearGradient(colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
                                          ]).createShader(rect);
                                        },
                                        child: Text(
                                          'terms and conditions',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        ))),
                                TextSpan(text: ' of use and the '),
                                WidgetSpan(
                                    child: ShaderMask(
                                        shaderCallback: (rect) {
                                          return LinearGradient(colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            Theme.of(context)
                                                .colorScheme
                                                .primaryVariant,
                                          ]).createShader(rect);
                                        },
                                        child: Text(
                                          'privacy policy.',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                        )))
                              ]),

                              // 'I agree to the terms and conditions of use and the privacy policy.',
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          );
        }),
      ),
    );
  }
}

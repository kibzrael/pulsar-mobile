import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/recover_account/recover_account.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/divider.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/select_language.dart';

class LoginPage extends StatefulWidget {
  final Function(int page) onChange;
  LoginPage({required this.onChange});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late LoginProvider loginProvider;

  int? maxHeight;

  bool isSubmitting = false;
  bool isSubmitted = false;

  FocusNode? userNode;
  FocusNode? passwordNode;

  TextEditingController? userController;
  TextEditingController? passwordController;

  @override
  void initState() {
    super.initState();
    userNode = FocusNode();
    passwordNode = FocusNode();
    userController = TextEditingController();
    passwordController = TextEditingController();
  }

  void login() async {
    loginProvider.login();
  }

  void onForgotPassword() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => RecoverAccountScreen()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loginProvider = Provider.of<LoginProvider>(context);

    double size =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    //
    //
    // get totalHeight of widgets:
    // if maxHeight < height then:
    //    height = totalHeight
    // else:
    //    height = maxHeight
    //
    //
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                height: size,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SelectLanguage(),
                    PulsarTextLogo(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: [
                        LogTextInput(
                          hintText: 'Username/Email/Phone',
                          controller: userController,
                          focusNode: userNode,
                          onFieldSubmitted: (_) {
                            passwordNode!.requestFocus();
                          },
                          onChanged: (_) {},
                        ),
                        SizedBox(height: 15),
                        LogTextInput(
                          hintText: 'Password',
                          isPassword: true,
                          obscureText: true,
                          controller: passwordController,
                          focusNode: passwordNode,
                          keyboardType: TextInputType.visiblePassword,
                          onFieldSubmitted: (_) {},
                          onChanged: (_) {},
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 50,
                              alignment: Alignment.topRight,
                              child: TextButton(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                    fontSize: 16.5,
                                  ),
                                ),
                                onPressed: onForgotPassword,
                              ),
                            ))
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        AuthButton(
                          isSubmitted: isSubmitted,
                          isSubmitting: isSubmitting,
                          onPressed: login,
                        ),
                        ToggleAuthScreen(
                          isLogin: true,
                          onChange: widget.onChange,
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [MyDivider(), LinkedAccountLogin()]),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

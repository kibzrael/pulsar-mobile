import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/recover_account/recover_account.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/select_language.dart';
import 'package:pulsar/widgets/text_button.dart';

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

  late FocusNode userNode;
  late FocusNode passwordNode;

  late TextEditingController userController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    userNode = FocusNode();
    passwordNode = FocusNode();
    userController = TextEditingController();
    passwordController = TextEditingController();
  }

  void login() async {
    String info = userController.text;
    String password = passwordController.text;
    setState(() {
      isSubmitting = true;
    });
    LoginResponse response = await loginProvider.login(context, info, password);
    setState(() {
      isSubmitting = false;
    });
    if (response.statusCode == 200) return;

    openDialog(
      context,
      (context) => MyDialog(
        title: statusCodes[response.statusCode]!,
        body: response.body!['message'],
        actions: ['Ok'],
      ),
    );
  }

  void onForgotPassword() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => RecoverAccountScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    userNode.dispose();
    passwordNode.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    loginProvider = Provider.of<LoginProvider>(context);

    double size =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    double topPadding = MediaQuery.of(context).padding.top;

    List<String> inputs = [userController.text, passwordController.text];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              margin: EdgeInsets.only(top: topPadding),
              height: size,
              child: Column(
                children: [
                  SelectLanguage(),
                  Spacer(),
                  PulsarLogo(
                    size: MediaQuery.of(context).size.width / 2.7,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: [
                      LogTextInput(
                        hintText: 'Username/Email/Phone',
                        controller: userController,
                        focusNode: userNode,
                        onFieldSubmitted: (_) {
                          passwordNode.requestFocus();
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 15),
                      LogTextInput(
                        hintText: 'Password',
                        isPassword: true,
                        obscureText: true,
                        controller: passwordController,
                        focusNode: passwordNode,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (_) {
                          if (!isSubmitting &&
                              !inputs.any((element) => element.length < 1)) {
                            login();
                          }
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 50,
                            alignment: Alignment.topRight,
                            child: MyTextButton(
                              text: 'Forgot Password?',
                              onPressed: onForgotPassword,
                            ),
                          ))
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: AuthButton(
                      isSubmitting: isSubmitting,
                      onPressed: login,
                      inputs: inputs,
                    ),
                  ),
                  LinkedAccountLogin(),
                  ToggleAuthScreen(
                    isLogin: true,
                    onChange: widget.onChange,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

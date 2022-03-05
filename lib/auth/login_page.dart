import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/menu.dart';
import 'package:pulsar/auth/recover_account/recover_account.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/text_button.dart';

class LoginPage extends StatefulWidget {
  final Function(int page) onChange;
  const LoginPage({Key? key, required this.onChange}) : super(key: key);
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
    FocusScope.of(context).unfocus();
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
        actions: const ['Ok'],
      ),
    );
  }

  void onForgotPassword() {
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => const RecoverAccountScreen()));
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

    // double topPadding = MediaQuery.of(context).padding.top;

    // double size =
    //     MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);

    List<String> inputs = [userController.text, passwordController.text];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              // constraints: BoxConstraints(minHeight: size),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            openBottomSheet(
                                context, (context) => const AuthMenu());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(MyIcons.menu, size: 30),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    child: Column(children: [
                      LogTextInput(
                        hintText: 'Username/ Email',
                        controller: userController,
                        focusNode: userNode,
                        onFieldSubmitted: (_) {
                          passwordNode.requestFocus();
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      LogTextInput(
                        hintText: 'Password',
                        isPassword: true,
                        obscureText: true,
                        controller: passwordController,
                        focusNode: passwordNode,
                        keyboardType: TextInputType.visiblePassword,
                        onFieldSubmitted: (_) {
                          if (!isSubmitting &&
                              !inputs.any((element) => element.isEmpty)) {
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
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: AuthButton(
                      isSubmitting: isSubmitting,
                      title: "Login",
                      onPressed: login,
                      inputs: inputs,
                    ),
                  ),
                  // const Spacer(),
                  const LinkedAccountLogin(),
                  // const Spacer(),
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

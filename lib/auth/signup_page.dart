import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/route.dart';

class SignupPage extends StatefulWidget {
  final Function(int page) onChange;
  SignupPage({required this.onChange});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late SignInfoProvider provider;

  late LoginProvider loginProvider;

  int signIndex = 0;

  bool isSubmitting = false;
  bool isSubmitted = false;

  late FocusNode emailNode;
  late FocusNode usernameNode;
  late FocusNode passwordNode;

  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailNode = FocusNode();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  // void selectCountryCode() {
  //   openBottomSheet(context, (context) => CountryCodes());
  // }

  void signup() async {
    String email = usernameController.text;
    String username = usernameController.text;
    String password = passwordController.text;
    setState(() {
      isSubmitting = true;
    });
    SignupResponse response = await provider.signup(email, username, password);
    setState(() {
      isSubmitting = false;
    });
    if (response.statusCode == 201) {
      setState(() {
        isSubmitted = true;
      });
      await Future.delayed(Duration(milliseconds: 300));
      provider.fetchInterests(context);

      provider.user.id = response.body!['user']['id'];
      provider.user.username = response.body!['user']['username'];

      await loginProvider.signup(context,
          token: response.body!['jwtToken'], user: response.body!['user']);
      Navigator.of(context, rootNavigator: true)
          .pushReplacement(myPageRoute(builder: (context) => SignInfo()));
      return;
    }

    openDialog(
      context,
      (context) => MyDialog(
        title: statusCodes[response.statusCode]!,
        body: response.body!['message'],
        actions: ['Ok'],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailNode.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    provider = Provider.of<SignInfoProvider>(context);
    loginProvider = Provider.of<LoginProvider>(context);

    double topPadding = MediaQuery.of(context).padding.top;

    double size =
        MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);

    List<String> inputs = [
      emailController.text,
      usernameController.text,
      passwordController.text
    ];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              height: size,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(MyIcons.menu, size: 30)
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Column(children: [
                      LogTextInput(
                        hintText: 'Email',
                        controller: emailController,
                        focusNode: emailNode,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) {
                          usernameNode.requestFocus();
                        },
                      ),
                      SizedBox(height: 15),
                      LogTextInput(
                        hintText: 'Username',
                        controller: usernameController,
                        focusNode: usernameNode,
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
                            signup();
                          }
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 15),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: AuthButton(
                      isSubmitting: isSubmitting,
                      isLogin: false,
                      onPressed: signup,
                      inputs: inputs,
                    ),
                  ),
                  LinkedAccountLogin(),
                  Spacer(),
                  ToggleAuthScreen(
                    isLogin: false,
                    onChange: widget.onChange,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class SelectCountry extends StatefulWidget {
  final Function() onPressed;
  final String code;
  final bool show;
  SelectCountry(
      {required this.code, required this.show, required this.onPressed});

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300), value: 0);

    animationController.animateTo(1);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        alignment: Alignment.centerLeft,
        firstChild: SizedBox(
          width: 100,
          height: 50,
          child: ScaleTransition(
            scale: animationController.view,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: widget.onPressed,
                child: Card(
                  elevation: 3,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.fromLTRB(3, 2, 8, 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.code,
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w500),
                        ),
                        Icon(MyIcons.expand)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        secondChild: Container(width: 1, height: 1),
        crossFadeState:
            widget.show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 300));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/floating_button.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/text_input.dart';

class LogCredentials extends StatefulWidget {
  @override
  _LogCredentialsState createState() => _LogCredentialsState();
}

class _LogCredentialsState extends State<LogCredentials> {
  late SignInfoProvider provider;

  late LoginProvider loginProvider;

  bool passwordObscure = true;

  bool isSubmitting = false;

  bool isSubmitted = false;

  late FocusNode usernameNode;
  late FocusNode passwordNode;

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void signup() async {
    String username = usernameController.text;
    String password = passwordController.text;
    setState(() {
      isSubmitting = true;
    });
    SignupResponse response = await provider.signup(username, password);
    setState(() {
      isSubmitting = false;
    });
    if (response.statusCode == 201) {
      setState(() {
        isSubmitted = true;
      });
      await Future.delayed(Duration(milliseconds: 300));
      provider.user.id = response.body!['user']['id'];
      provider.user.username = response.body!['user']['username'];

      await loginProvider.signup(context,
          token: response.body!['jwtToken'], user: response.body!['user']);
      provider.nextPage();
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
    usernameController.dispose();
    passwordController.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);
    loginProvider = Provider.of<LoginProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Credentials'),
            centerTitle: true,
          ),
          floatingActionButton: MyFloatingActionButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              signup();
            },
            child: isSubmitted
                ? Icon(MyIcons.check, size: 30)
                : isSubmitting
                    ? Padding(
                        padding: EdgeInsets.all(12.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: MyProgressIndicator(
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : Icon(MyIcons.forward, size: 30),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: size,
              padding: EdgeInsets.all(30),
              child: Column(children: [
                Text(
                  'Please select a suitable username and password',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                Spacer(flex: 1),
                MyTextInput(
                  hintText: 'Username',
                  controller: usernameController,
                  focusNode: usernameNode,
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {
                    passwordNode.requestFocus();
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Only letters, numbers, . and _ are allowed.',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                MyTextInput(
                  hintText: 'Password',
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {},
                  obscureText: passwordObscure,
                  controller: passwordController,
                  focusNode: passwordNode,
                  suffix: InkWell(
                    child: Icon(
                      passwordObscure ? Icons.visibility_off : Icons.visibility,
                      color: passwordObscure
                          ? Colors.grey
                          : Theme.of(context).accentColor,
                    ),
                    onTap: () {
                      setState(
                        () {
                          passwordObscure = !passwordObscure;
                        },
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Minimum of 6 characters.',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                )
              ]),
            ),
          )),
    );
  }
}

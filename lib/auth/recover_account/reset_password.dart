import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/text_input.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late RecoverAccountProvider recoverAccountProvider;

  bool obscureText = true;

  void onReset() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    recoverAccountProvider =
        Provider.of<RecoverAccountProvider>(context, listen: false);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(MyIcons.back),
              onPressed: () {
                recoverAccountProvider.previousPage();
              },
            ),
            title: Text('Reset Password')),
        body: SingleChildScrollView(
            child: Container(
          height: size,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text(
                  'Please enter your new password. Be sure to remember this one.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1),
              Spacer(flex: 1),
              MyTextInput(
                  hintText: 'Password',
                  obscureText: obscureText,
                  onChanged: (text) {},
                  onSubmitted: (text) {}),
              SizedBox(
                height: 15,
              ),
              MyTextInput(
                  hintText: 'Confirm Password',
                  obscureText: obscureText,
                  onChanged: (text) {},
                  onSubmitted: (text) {}),
              SizedBox(height: 15),
              InkWell(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(obscureText ? 'Show Password:' : 'Hide password:',
                            style: Theme.of(context).textTheme.subtitle1),
                        Icon(obscureText ? MyIcons.eyeOff : MyIcons.eye),
                      ]),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              ActionButton(
                title: 'Reset',
                onPressed: onReset,
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

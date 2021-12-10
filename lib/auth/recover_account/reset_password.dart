import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_input.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late RecoverAccountProvider recoverAccountProvider;

  String password = '';
  String confirmPassword = '';

  bool match = true;

  bool obscureText = true;

  bool isSubmitting = false;

  void onReset() async {
    if (password != confirmPassword) {
      openDialog(
        context,
        (context) => MyDialog(
          title: 'Warning!',
          body: "The two passwords you've entered do not match.",
          actions: ['Ok'],
        ),
        dismissible: true,
      );
    } else {
      setState(() => isSubmitting = true);
      await recoverAccountProvider.resetPassword(password);
      setState(() => isSubmitting = false);
      await openDialog(
        context,
        (context) => MyDialog(
          title: 'Success',
          body: "You have successfully changed your password.",
          actions: ['Ok'],
        ),
        dismissible: true,
      );
      Navigator.pop(context);
    }
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
                  style: Theme.of(context).textTheme.headline1),
              Spacer(flex: 1),
              MyTextInput(
                  hintText: 'Password',
                  obscureText: obscureText,
                  onChanged: (text) => setState(() => password = text),
                  onSubmitted: (text) {}),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
              SizedBox(
                height: 15,
              ),
              MyTextInput(
                  hintText: 'Confirm Password',
                  obscureText: obscureText,
                  onChanged: (text) {
                    setState(() {
                      match = password.startsWith(text);
                      confirmPassword = text;
                    });
                  },
                  onSubmitted: (text) {}),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Text(
                    match ? '' : 'The passwords do not match!',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ),
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
                        Text('Show Password:',
                            style: Theme.of(context).textTheme.subtitle1),
                        Checkbox(
                            value: !obscureText,
                            onChanged: (value) {
                              bool state = value ?? false;
                              setState(() {
                                obscureText = !state;
                              });
                            })
                      ]),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              AuthButton(
                title: 'Reset',
                isSubmitting: isSubmitting,
                onPressed: onReset,
                inputs: [password, confirmPassword],
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

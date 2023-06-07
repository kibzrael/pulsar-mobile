import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_input.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
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
          title: local(context).warning,
          body: local(context).passwordMatchDescription,
          actions: [local(context).ok],
        ),
        dismissible: true,
      );
    } else {
      setState(() => isSubmitting = true);
      await recoverAccountProvider.resetPassword(password).then((response) {
        setState(() => isSubmitting = false);
        openDialog(
          context,
          (context) => MyDialog(
            // TODO: localize titles
            title: statusCodes[response.statusCode]!,
            // TODO: localize message
            body: response.body!['message'],
            actions: [local(context).ok],
          ),
          dismissible: true,
        ).then((_) {
          if (response.statusCode == 200) {
            Navigator.pop(context);
          }
        });
      });
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
            title: Text(local(context).resetPassword)),
        body: SingleChildScrollView(
            child: Container(
          height: size,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Text(local(context).resetPasswordTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge),
              const Spacer(flex: 1),
              MyTextInput(
                  hintText: local(context).password,
                  obscureText: obscureText,
                  onChanged: (text) => setState(() {
                        if (confirmPassword.isNotEmpty) {
                          match = text.startsWith(confirmPassword);
                        }

                        password = text;
                      }),
                  onSubmitted: (text) {}),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      local(context).passwordDescription,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextInput(
                  hintText: local(context).confirmPassword,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  child: Text(
                    match ? '' : local(context).passwordMatchError,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${local(context).showPassword}:',
                            style: Theme.of(context).textTheme.titleLarge),
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
              const Spacer(
                flex: 1,
              ),
              AuthButton(
                title: local(context).reset,
                isSubmitting: isSubmitting,
                onPressed: onReset,
                inputs: [password, confirmPassword],
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

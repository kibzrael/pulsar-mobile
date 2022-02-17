import 'package:flutter/material.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/widgets/text_input.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password = '';
  String newPassword = '';

  bool obscureText = true;

  bool isSubmitting = false;

  onSubmit() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Change Password')),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: Container(
            height: constraints.maxHeight,
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Text(
                    'TODO:(Change text) Please enter your new password. Be sure to remember this one.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1),
                const Spacer(flex: 1),
                MyTextInput(
                    hintText: 'Password',
                    obscureText: obscureText,
                    onChanged: (text) => setState(() => password = text),
                    onSubmitted: (text) {}),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                const SizedBox(
                  height: 15,
                ),
                MyTextInput(
                    hintText: 'Confirm Password',
                    obscureText: obscureText,
                    onChanged: (text) {
                      setState(() {
                        newPassword = text;
                      });
                    },
                    onSubmitted: (text) {}),
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
                const Spacer(
                  flex: 1,
                ),
                AuthButton(
                  title: 'Reset',
                  isSubmitting: isSubmitting,
                  onPressed: onSubmit,
                  inputs: [password, newPassword],
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}

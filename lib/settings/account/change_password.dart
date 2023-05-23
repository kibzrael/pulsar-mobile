import 'package:flutter/material.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/text_input.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String password = '';
  String newPassword = '';

  bool obscureText = true;

  bool isSubmitting = false;

  onSubmit() {}

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    double size =
        MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(local(context).changePassword)),
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
                  onChanged: (text) => setState(() => password = text),
                  onSubmitted: (text) {}),
              const SizedBox(
                height: 15,
              ),
              MyTextInput(
                  hintText: local(context).newPassword,
                  obscureText: obscureText,
                  onChanged: (text) {
                    setState(() {
                      newPassword = text;
                    });
                  },
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
                title: local(context).submit,
                isSubmitting: isSubmitting,
                onPressed: onSubmit,
                inputs: [password, newPassword],
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_input.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late UserProvider provider;

  String old = '';
  String password = '';

  bool obscureText = true;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<UserProvider>(context, listen: false);
  }

  onSubmit() async {
    setState(() => isSubmitting = true);
    await provider.changePassword(context, old, password).then((response) {
      openDialog(
        context,
        (context) => MyDialog(
          title: statusCodes[response.statusCode] ?? "Server Error",
          body: response.body != null
              ? response.body!['message']
              : "Something went wrong, Try again later",
          actions: [local(context).ok],
        ),
        dismissible: true,
      ).then((_) {
        if (response.statusCode == 200) {
          Navigator.pop(context);
        }
      });
    });
    setState(() => isSubmitting = false);
  }

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
              Text(local(context).changePasswordTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge),
              const Spacer(flex: 1),
              MyTextInput(
                  hintText: local(context).password,
                  obscureText: obscureText,
                  onChanged: (text) => setState(() => old = text),
                  onSubmitted: (text) {}),
              const SizedBox(
                height: 15,
              ),
              MyTextInput(
                  hintText: local(context).newPassword,
                  obscureText: obscureText,
                  onChanged: (text) {
                    setState(() {
                      password = text;
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
                inputs: [old, password],
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

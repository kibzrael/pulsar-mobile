// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulsar/providers/login_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/divider.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/text_button.dart';

class LogTextDecoration extends InputDecoration {
  @override
  final String hintText;
  @override
  final EdgeInsetsGeometry contentPadding =
      const EdgeInsets.symmetric(horizontal: 18, vertical: 0);
  @override
  final InputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  @override
  final InputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  @override
  final InputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  @override
  final InputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  @override
  final int errorMaxLines = 1;
  @override
  final String? counterText = '';
  @override
  final bool filled = true;
  @override
  final Color? fillColor;
  @override
  final Widget? suffixIcon;
  @override
  final Widget? prefixIcon;
  LogTextDecoration(
      {this.hintText = '',
      required this.fillColor,
      this.suffixIcon,
      this.prefixIcon});
}

class LogTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final List<TextInputFormatter> inputFormatters;
  final String hintText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? prefix;
  final int? max;
  const LogTextInput(
      {Key? key,
      this.controller,
      this.focusNode,
      this.hintText = '',
      this.inputFormatters = const [],
      this.isPassword = false,
      this.obscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.max,
      this.keyboardType = TextInputType.text,
      this.prefix,
      this.prefixIcon})
      : super(key: key);
  @override
  State<LogTextInput> createState() => _LogTextInputState();
}

class _LogTextInputState extends State<LogTextInput> {
  late bool passwordObscure;
  @override
  void initState() {
    passwordObscure = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          if (widget.prefix != null) widget.prefix!,
          Flexible(
            child: TextFormField(
              keyboardAppearance: Theme.of(context).brightness,
              focusNode: widget.focusNode,
              controller: widget.controller,
              obscureText: passwordObscure,
              onFieldSubmitted: (String text) {
                widget.onFieldSubmitted!(text);
              },
              onChanged: (String text) {
                widget.onChanged!(text);
              },
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.max,
              decoration: LogTextDecoration(
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPassword
                    ? InkWell(
                        child: Container(
                          width: 75,
                          height: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  color: Theme.of(context).dividerColor),
                            ),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                primaryGradient().createShader(bounds),
                            child: Text(passwordObscure ? 'Show' : 'Hide',
                                style: const TextStyle(
                                    fontSize: 16.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        onTap: () {
                          setState(
                            () {
                              passwordObscure = !passwordObscure;
                            },
                          );
                        },
                      )
                    : null,
                hintText: widget.hintText,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleAuthScreen extends StatelessWidget {
  final Function(int page) onChange;
  final bool isLogin;

  const ToggleAuthScreen(
      {Key? key, required this.onChange, this.isLogin = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            isLogin ? "Don't have an account?" : 'Already have an account?',
            style: const TextStyle(fontSize: 16.5),
          ),
          MyTextButton(
              text: isLogin ? 'Signup' : 'Login',
              onPressed: () {
                onChange(isLogin ? 1 : 0);
              })
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final bool isSubmitting;
  final Function onPressed;
  final List<String> inputs;

  final String title;
  const AuthButton({
    Key? key,
    this.isSubmitting = false,
    this.inputs = const [],
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool enabled = !isSubmitting && !inputs.any((element) => element.isEmpty);
    return InkWell(
      onTap: enabled ? onPressed as void Function()? : null,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: primaryGradient(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 32,
                width: 32,
                child: MyProgressIndicator(
                  size: 32,
                  margin: EdgeInsets.zero,
                ))
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}

class LinkedAccountLogin extends StatelessWidget {
  final LoginProvider provider;
  final Color? color;
  final String text;
  final Color? dividerColor;
  final bool divider;

  const LinkedAccountLogin(this.provider,
      {Key? key,
      this.color,
      this.dividerColor,
      this.text = 'Login',
      this.divider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          if (divider)
            MyDivider(
              color: dividerColor,
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinkedAccountWidget(
                icon: 'assets/images/logos/google.png',
                name: 'Google',
                onPressed: () => provider.googleSignin(context),
                color: color,
                text: text,
              ),
              LinkedAccountWidget(
                icon: 'assets/images/logos/facebook.png',
                name: 'Facebook',
                onPressed: () => provider.facebookSignin(context),
                color: color,
                text: text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LinkedAccountWidget extends StatelessWidget {
  final String icon;
  final String name;
  final String text;
  final Function() onPressed;
  final Color? color;

  const LinkedAccountWidget(
      {Key? key,
      required this.icon,
      required this.name,
      required this.text,
      required this.onPressed,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
        color: color ?? Theme.of(context).cardColor,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          width: double.infinity,
          child: Row(children: [
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(icon))),
            ),
            const SizedBox(width: 30),
            Expanded(
                child: Text(
              '$text with $name',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 16.5),
            ))
          ]),
        ),
      ),
    );
  }
}

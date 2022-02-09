// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const LogTextInput(
      {Key? key, this.controller,
      this.focusNode,
      this.hintText = '',
      this.inputFormatters = const [],
      this.isPassword = false,
      this.obscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.keyboardType = TextInputType.text,
      this.prefix,
      this.prefixIcon}) : super(key: key);
  @override
  _LogTextInputState createState() => _LogTextInputState();
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

  const ToggleAuthScreen({Key? key, required this.onChange, this.isLogin = true}) : super(key: key);
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
  final bool? isSubmitting;
  final Function onPressed;
  final List<String> inputs;

  final String title;
  const AuthButton({Key? key, 
    this.isSubmitting,
    this.inputs = const [],
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool enabled =
        !isSubmitting! && !inputs.any((element) => element.isEmpty);
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
        child: isSubmitting!
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
  final Color? color;
  final Color? dividerColor;

  const LinkedAccountLogin({Key? key, this.color, this.dividerColor}) : super(key: key);

  void onGoogle() {}
  void onFacebook() {}
  void onTwitter() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Column(
        children: [
          MyDivider(
            color: dividerColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LinkedAccountWidget(
                icon: 'assets/images/logos/google.png',
                onPressed: onGoogle,
                color: color,
              ),
              LinkedAccountWidget(
                icon: 'assets/images/logos/facebook.png',
                onPressed: onFacebook,
                color: color,
              ),
              LinkedAccountWidget(
                icon: 'assets/images/logos/twitter.png',
                onPressed: onTwitter,
                color: color,
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
  final Function() onPressed;
  final Color? color;

 const LinkedAccountWidget(
      {Key? key, required this.icon, required this.onPressed, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        shape: const CircleBorder(),
        elevation: 3,
        color: color ?? Theme.of(context).cardColor,
        child: Container(
          margin: const EdgeInsets.all(12),
          width: 27,
          height: 27,
          decoration:
              BoxDecoration(image: DecorationImage(image: AssetImage(icon))),
        ),
      ),
    );
  }
}

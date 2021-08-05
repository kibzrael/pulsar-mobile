import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulsar/classes/icons.dart';

class LogTextDecoration extends InputDecoration {
  final String hintText;
  final EdgeInsetsGeometry contentPadding =
      EdgeInsets.symmetric(horizontal: 18, vertical: 0);
  final InputBorder focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  final InputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  final InputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  final InputBorder focusedErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  );
  final int errorMaxLines = 1;
  final bool filled = true;
  final Color? fillColor;
  final Widget? suffixIcon;
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
  LogTextInput(
      {this.controller,
      this.focusNode,
      this.hintText = '',
      this.inputFormatters = const [],
      this.isPassword = false,
      this.obscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.keyboardType = TextInputType.text,
      this.prefix,
      this.prefixIcon});
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
                        child: Icon(
                          passwordObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
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

  ToggleAuthScreen({required this.onChange, this.isLogin = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            isLogin ? "Don't have an account?" : 'Already have an account?',
            style: TextStyle(fontSize: 16.5),
          ),
          InkWell(
              onTap: () {
                onChange(isLogin ? 1 : 0);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  isLogin ? 'Signup' : 'Login',
                  style: TextStyle(
                      fontSize: 16.5, color: Theme.of(context).buttonColor),
                ),
              ))
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final bool? isSubmitting;
  final Function onPressed;
  final List<String> inputs;

  ///Default is true
  final bool isLogin;
  AuthButton({
    this.isSubmitting,
    this.inputs = const [],
    this.isLogin = true,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    bool enabled =
        !isSubmitting! && !inputs.any((element) => element.length < 1);
    bool colored = !inputs.any((element) => element.length < 1);
    return InkWell(
      onTap: enabled ? onPressed as void Function()? : null,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        // foregroundDecoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(30),
        //     color: !enabled
        //         ? Theme.of(context).brightness == Brightness.light
        //             ? Colors.white38
        //             : Colors.black38
        //         : Colors.transparent),
        decoration: colored
            ? BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).buttonColor
                ]),
                borderRadius: BorderRadius.circular(30),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).disabledColor),
        child: isSubmitting!
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              )
            : Text(
                isLogin ? 'Login' : 'Signup',
                style: TextStyle(
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
  void onGoogle() {}
  void onFacebook() {}
  void onTwitter() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(MyIcons.google), onPressed: onGoogle),
          IconButton(icon: Icon(MyIcons.facebook), onPressed: onFacebook),
          IconButton(icon: Icon(MyIcons.twitter), onPressed: onTwitter),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/action_button.dart';

class VerifyCode extends StatefulWidget {
  final SignupInfo info;
  final Widget? leading;
  final Function()? onBack;
  final Function() onDone;

  VerifyCode(
      {required this.info, this.leading, this.onBack, required this.onDone});

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  int timeCountdown = 5;

  @override
  Widget build(BuildContext context) {
    Color? fillColor = Theme.of(context).inputDecorationTheme.fillColor;
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
              if (widget.onBack != null) {
                widget.onBack!();
              }
            },
          ),
          title: Text('Recovery Code'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Column(children: [
              if (widget.leading != null) widget.leading!,
              Text(
                'A code has been sent to ${widget.info.account}. Please enter the code below.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(flex: 2),
              Container(
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  keyboardType: TextInputType.number,
                  enableActiveFill: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldWidth: 50,
                      fieldHeight: 50,
                      borderWidth: 0.0,
                      activeFillColor: fillColor,
                      inactiveFillColor: fillColor,
                      selectedFillColor: fillColor,
                      activeColor: fillColor,
                      inactiveColor: fillColor,
                      selectedColor: fillColor,
                      disabledColor: fillColor),
                  onChanged: (_) {},
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    'Resend Code in $timeCountdown seconds?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryVariant),
                  ),
                  onPressed: () {},
                ),
              ),
              Spacer(flex: 1),
              ActionButton(
                title: 'Confirm',
                onPressed: () {
                  widget.onDone();
                },
              ),
              Spacer(flex: 3)
            ]),
          ),
        ),
      ),
    );
  }
}

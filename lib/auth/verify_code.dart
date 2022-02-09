import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/text_button.dart';

class VerifyCode extends StatefulWidget {
  final String account;
  final Widget? leading;
  final Function()? onBack;
  final Function() onDone;
  final Function(String code) verify;

  const VerifyCode(
      {Key? key, required this.account,
      this.leading,
      required this.verify,
      this.onBack,
      required this.onDone}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  int timeCountdown = 15;

  String code = '';

  bool isSubmitting = false;

  verify() async {
    setState(() => isSubmitting = true);
    await widget.verify(code);
    setState(() => isSubmitting = false);
    widget.onDone();
  }

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
          title: const Text('Recovery Code'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Column(children: [
              if (widget.leading != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: widget.leading!,
                ),
              Text(
                'A code has been sent to ${widget.account}. Please enter the code below.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
              const Spacer(flex: 2),
              PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                enableActiveFill: true,
                showCursor: false,
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
                    selectedFillColor: Theme.of(context).dividerColor,
                    activeColor: fillColor,
                    inactiveColor: fillColor,
                    selectedColor: Theme.of(context).dividerColor,
                    disabledColor: fillColor),
                onChanged: (text) => code = text,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MyTextButton(
                    text: "Resend Code in $timeCountdown seconds?",
                    fontSize: 16.5,
                    onPressed: () {}),
              ),
              const Spacer(flex: 1),
              AuthButton(
                title: 'Confirm',
                onPressed: verify,
                isSubmitting: isSubmitting,
                inputs: [code],
              ),
              const Spacer(flex: 3)
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class VerifyCode extends StatefulWidget {
  final String account;
  final Widget? leading;
  final Function()? onBack;
  final Function() onDone;
  final Function() resend;
  final Function(String code) verify;

  const VerifyCode({
    Key? key,
    required this.account,
    this.leading,
    required this.verify,
    this.onBack,
    required this.onDone,
    required this.resend,
  }) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  int timeCountdown = 15;

  String code = '';

  @override
  void initState() {
    super.initState();
    countdown();
  }

  countdown() async {
    if (timeCountdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => timeCountdown -= 1);
        countdown();
      }
    }
  }

  verify() {
    int response = widget.verify(code);
    if (response == 0) {
      widget.onDone();
    } else {
      openDialog(
        context,
        (context) => const MyDialog(
          title: 'Invalid',
          body:
              'The code entered does not match the one sent. Please try again.',
          actions: ['Ok'],
        ),
      );
    }
  }

  resend() {
    if (timeCountdown > 0) {
      return;
    }
    widget.resend();
    timeCountdown = 15;
    countdown();
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
                onCompleted: (_) => verify(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MyTextButton(
                    text: timeCountdown > 0
                        ? "Resend Code in $timeCountdown"
                        : "Resend Code",
                    fontSize: 16.5,
                    enabled: timeCountdown <= 0,
                    onPressed: resend),
              ),
              const Spacer(flex: 1),
              AuthButton(
                title: 'Confirm',
                onPressed: verify,
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

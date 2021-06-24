import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/action_button.dart';

class RecoveryCode extends StatefulWidget {
  @override
  _RecoveryCodeState createState() => _RecoveryCodeState();
}

class _RecoveryCodeState extends State<RecoveryCode> {
  late RecoverAccountProvider recoverAccountProvider;

  int timeCountdown = 5;

  String account = 'kib*******7@gmail.com';
  String username = '@username';
  String category = 'Artist';

  late User user;

  @override
  Widget build(BuildContext context) {
    recoverAccountProvider =
        Provider.of<RecoverAccountProvider>(context, listen: false);

    user = recoverAccountProvider.user!;

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
              recoverAccountProvider.previousPage();
            },
          ),
          title: Text('Recovery Code'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            child: Column(children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                margin: EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: Theme.of(context).dividerColor,
                        backgroundImage: AssetImage('${user.profilePic}'),
                        radius: 36),
                    SizedBox(width: 15),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('@${user.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(fontSize: 21)),
                          SizedBox(
                            height: 2.5,
                          ),
                          Text('${user.category}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(fontSize: 18)),
                        ])
                  ],
                ),
              ),
              Text(
                'A code has been sent to $account. Please enter the code below.',
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
                    style: TextStyle(color: Theme.of(context).buttonColor),
                  ),
                  onPressed: () {},
                ),
              ),
              Spacer(flex: 1),
              ActionButton(
                title: 'Confirm',
                onPressed: () {
                  recoverAccountProvider.nextPage();
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

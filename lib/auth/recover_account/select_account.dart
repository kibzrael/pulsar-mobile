import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/action_button.dart';
import 'package:pulsar/widgets/text_input.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({Key? key}) : super(key: key);

  @override
  _SelectAccountState createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  late RecoverAccountProvider recoverAccountProvider;

  void onChanged(text) {}

  void onSubmitted(text) {
    recoverAccountProvider.recoverAccount(text);
  }

  String email = 'kib*******7@gmail.com';
  String phone = '+254734****86';

  void onEmail() {
    recoverAccountProvider.nextPage();
  }

  void onPhone() {
    recoverAccountProvider.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    recoverAccountProvider =
        Provider.of<RecoverAccountProvider>(context, listen: false);

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
              Navigator.pop(context);
            },
          ),
          title: const Text('Recover Account'),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: size,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    'Select the account to recover. Recover using either email or phone.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const Spacer(flex: 2),
                  MyTextInput(
                    hintText: 'Username/Phone/Email',
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                  ),
                  const Spacer(flex: 1),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          softWrap: false,
                          maxLines: 1,
                          text: TextSpan(
                              text: 'Email:    ',
                              style: Theme.of(context).textTheme.subtitle1,
                              children: [
                                TextSpan(
                                    text: email,
                                    style:
                                        Theme.of(context).textTheme.subtitle2)
                              ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RichText(
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: 'Phone:    ',
                              style: Theme.of(context).textTheme.subtitle1,
                              children: [
                                TextSpan(
                                    text: phone,
                                    style:
                                        Theme.of(context).textTheme.subtitle2)
                              ]),
                        )
                      ]),
                  const Spacer(flex: 1),
                  Row(
                    children: [
                      Flexible(
                        child: ActionButton(
                          title: 'Email',
                          height: 50,
                          backgroundColor: Theme.of(context).disabledColor,
                          titleColor:
                              Theme.of(context).textTheme.bodyText2!.color,
                          onPressed: onEmail,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: ActionButton(
                          title: 'Phone',
                          height: 50,
                          onPressed: onPhone,
                        ),
                      )
                    ],
                  ),
                  const Spacer(
                    flex: 3,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

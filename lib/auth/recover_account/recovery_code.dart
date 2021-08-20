import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/auth/signup_page.dart';
import 'package:pulsar/auth/verify_code.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class RecoveryCode extends StatefulWidget {
  @override
  _RecoveryCodeState createState() => _RecoveryCodeState();
}

class _RecoveryCodeState extends State<RecoveryCode> {
  late RecoverAccountProvider recoverAccountProvider;

  late User user;

  @override
  Widget build(BuildContext context) {
    recoverAccountProvider =
        Provider.of<RecoverAccountProvider>(context, listen: false);

    user = recoverAccountProvider.user!;

    SignupInfo account = SignupInfo(email: 'kib*******7@gmail.com');

    return VerifyCode(
      info: account,
      onBack: recoverAccountProvider.previousPage,
      onDone: recoverAccountProvider.nextPage,
      leading: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(user.profilePic, radius: 36),
            SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    );
  }
}

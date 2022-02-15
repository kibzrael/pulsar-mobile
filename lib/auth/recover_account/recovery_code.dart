import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/auth/verify_code.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class RecoveryCode extends StatefulWidget {
  const RecoveryCode({Key? key}) : super(key: key);

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

    String account = user.email!;

    return VerifyCode(
      account: account,
      verify: recoverAccountProvider.verifyCode,
      onBack: recoverAccountProvider.previousPage,
      onDone: recoverAccountProvider.nextPage,
      resend: () {
        recoverAccountProvider.recoverAccount(user.email!);
      },
      leading: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(user.profilePic?.thumbnail, radius: 36),
            const SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('@${user.username}',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 21)),
              const SizedBox(
                height: 2.5,
              ),
              Text(user.category ?? 'Personal Account',
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

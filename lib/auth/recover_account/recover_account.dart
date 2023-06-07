import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/auth/recover_account/recovery_code.dart';
import 'package:pulsar/auth/recover_account/reset_password.dart';
import 'package:pulsar/auth/recover_account/select_account.dart';

class RecoverAccountScreen extends StatefulWidget {
  const RecoverAccountScreen({Key? key}) : super(key: key);

  @override
  State<RecoverAccountScreen> createState() => _RecoverAccountScreenState();
}

class _RecoverAccountScreenState extends State<RecoverAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecoverAccountProvider(),
      builder: (context, child) {
        return Consumer<RecoverAccountProvider>(
          builder: (context, RecoverAccountProvider provider, child) {
            return Scaffold(
              body: PageView(
                controller: provider.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SelectAccount(),
                  RecoveryCode(),
                  ResetPassword(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

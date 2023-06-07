import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/recover_account/recover_account_provider.dart';
import 'package:pulsar/auth/widgets.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_input.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({Key? key}) : super(key: key);

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  late RecoverAccountProvider recoverAccountProvider;
  bool isSubmitting = false;

  String info = '';

  recover() async {
    setState(() => isSubmitting = true);
    await recoverAccountProvider.recoverAccount(info.trim()).then((response) {
      setState(() => isSubmitting = false);
      if (response.statusCode == 200) {
        recoverAccountProvider.nextPage();
        return;
      }

      openDialog(
        context,
        (context) => MyDialog(
          title: statusCodes[response.statusCode]!,
          body: response.body!['message'],
          actions: const ['Ok'],
        ),
      );
    });
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
          title: Text(local(context).recoverAccount),
        ),
        body: SingleChildScrollView(
          child: Container(
              height: size,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    local(context).recoverAccountTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Spacer(flex: 2),
                  MyTextInput(
                    hintText:
                        '${local(context).username} / ${local(context).email}',
                    onChanged: (text) => info = text,
                    onSubmitted: (text) {
                      info = text;
                      recover();
                    },
                  ),
                  const Spacer(flex: 1),
                  AuthButton(
                    title: local(context).confirm,
                    onPressed: recover,
                    isSubmitting: isSubmitting,
                    inputs: [info],
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

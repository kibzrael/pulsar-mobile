import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  late UserProvider provider;
  late TextEditingController controller;

  // bool isLoading = false;

  String text = '';

  @override
  void initState() {
    super.initState();
    provider = Provider.of<UserProvider>(context, listen: false);
    controller = TextEditingController(text: provider.user.username);
    text = provider.user.username;
  }

  // checkUsername() async {
  //   setState(() => isLoading = true);
  //   await Future.delayed(const Duration(seconds: 2));
  //   setState(() => isLoading = false);
  // }

  onSubmit() async {
    openDialog(
        context,
        (context) => LoadingDialog(
              (_) async => await provider.changeUsername(context, text),
              text: local(context).submitting,
            )).then((response) {
      openDialog(
        context,
        (context) => MyDialog(
          title: statusCodes[response.statusCode]!,
          body: response.body!['message'],
          actions: [local(context).ok],
        ),
        dismissible: true,
      ).then((_) {
        if (response.statusCode == 200) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    double size =
        MediaQuery.of(context).size.height - (topPadding + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(local(context).changeUsername),
          actions: [
            MyTextButton(text: local(context).done, onPressed: onSubmit)
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          height: size,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Text(local(context).usernameTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: local(context).username,
                      // suffixIcon: isLoading
                      //     ? const MyProgressIndicator(
                      //         size: 20,
                      //         margin: EdgeInsets.zero,
                      //       )
                      //     : Icon(MyIcons.close),
                      helperText: local(context).usernameDescription,
                      helperMaxLines: 4),
                  onChanged: (value) => setState(() {
                        text = value;
                        // checkUsername();
                      }),
                  onSubmitted: (value) => text = ''),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }
}

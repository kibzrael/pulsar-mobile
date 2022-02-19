import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/response.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
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
    MyResponse response = await openDialog(
        context,
        (context) => LoadingDialog(
              () async => await provider.changeUsername(context, text),
              text: 'Submitting',
            ));
    await openDialog(
      context,
      (context) => MyDialog(
        title: statusCodes[response.statusCode]!,
        body: response.body!['message'],
        actions: const ['Ok'],
      ),
      dismissible: true,
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
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
          title: const Text('Change username'),
          actions: [MyTextButton(text: 'Done', onPressed: onSubmit)],
        ),
        body: SingleChildScrollView(
            child: Container(
          height: size,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Text('Enter the username\nyou\'d like to use.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 30),
              TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Username',
                      // suffixIcon: isLoading
                      //     ? const MyProgressIndicator(
                      //         size: 20,
                      //         margin: EdgeInsets.zero,
                      //       )
                      //     : Icon(MyIcons.close),
                      helperText:
                          'Only letters, numbers, underscores(_) and periods(.) are allowed',
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/auth/verify_code.dart';
import 'package:pulsar/classes/status_codes.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/auth.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/loading_dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  late PageController pageController;
  late TextEditingController controller;
  late UserProvider provider;

  int? verificationCode;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    provider = Provider.of<UserProvider>(context, listen: false);
    controller = TextEditingController(text: provider.user.email);
    sendCode();
  }

  sendCode({String? account}) async {
    String verifyEmailUrl = getUrl(AuthUrls.verifyEmail);

    try {
      var requestBody = {'email': account ?? provider.user.email};
      if (account != null) {
        requestBody['username'] = provider.user.username;
      }
      http.Response response =
          await http.post(Uri.parse(verifyEmailUrl), body: requestBody);

      //
      var body = jsonDecode(response.body);

      if (account != null) {
        if (response.statusCode == 409) {
          Fluttertoast.showToast(
              msg: 'The email already exists. Please try another one.');
          pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
          return;
        }
      }

      if (body is Map) {
        verificationCode = body['code'];
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'There has been a problem processing your request. Please try again later.');
    }
  }

  verify(String code) {
    if (verificationCode.toString() == code) {
      return 0;
    } else {
      return 1;
    }
  }

  onSubmit() async {
    openDialog(
        context,
        (context) => LoadingDialog(
              (_) async => await provider.changeEmail(context, controller.text),
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
    return Scaffold(
      body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            VerifyCode(
                account: provider.user.email ?? '',
                verify: verify,
                onDone: () {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
                onBack: () {
                  Navigator.pop(context);
                },
                resend: sendCode),
            GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(local(context).changeEmail),
                    actions: [
                      MyTextButton(
                          text: local(context).done,
                          onPressed: () {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear);
                            sendCode(account: controller.text.trim());
                          })
                    ],
                  ),
                  body: SingleChildScrollView(
                      child: Container(
                    height: size,
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(local(context).emailTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 30),
                        TextField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: local(context).email,
                              helperMaxLines: 4),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )),
                )),
            VerifyCode(
                account: controller.text.trim(),
                verify: verify,
                onDone: onSubmit,
                onBack: () {
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
                resend: () => sendCode(account: controller.text.trim())),
          ]),
    );
  }
}

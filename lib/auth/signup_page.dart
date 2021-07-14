import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/auth/country_code.dart';
import 'package:pulsar/auth/log_widget.dart';
import 'package:pulsar/auth/sign_info/info_verification.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/widgets/divider.dart';
import 'package:pulsar/widgets/logo.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/select_language.dart';

class SignupPage extends StatefulWidget {
  final Function(int page) onChange;
  SignupPage({required this.onChange});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int signIndex = 1;

  bool isSubmitting = false;
  bool isSubmitted = false;

  late FocusNode userNode;

  late TextEditingController userController;
  String countryCode = '+254';

  @override
  void initState() {
    super.initState();
    userNode = FocusNode();
    userController = TextEditingController();
  }

  void selectCountryCode() {
    openBottomSheet(context, (context) => CountryCodes());
  }

  void signup() {
    SignupInfo info = SignupInfo();

    bool phone = signIndex == 1;
    String account = '${phone ? countryCode : ''}' + userController.text;
    if (phone) {
      info.phone = account;
    } else {
      info.email = account;
    }
    Navigator.of(context)
        .push(myPageRoute(builder: (context) => InfoVerification(info: info)));
  }

  void onIndexChange(index) {
    setState(() {
      signIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    userNode.dispose();
    userController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double size =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    List<String> inputs = [userController.text];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                height: size,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectLanguage(),
                    PulsarTextLogo(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(children: [
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: CupertinoSlidingSegmentedControl(
                              groupValue: signIndex,
                              children: {
                                0: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Text(
                                      'Email',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                1: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Text(
                                      'Phone',
                                      style: TextStyle(fontSize: 18),
                                    ))
                              },
                              onValueChanged: onIndexChange),
                        ),
                        SizedBox(height: 15),
                        LogTextInput(
                          hintText: signIndex == 0 ? 'Email' : 'Phone',
                          controller: userController,
                          focusNode: userNode,
                          onChanged: (_) {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {
                            if (!isSubmitting &&
                                !inputs.any((element) => element.length < 1)) {
                              signup();
                            }
                          },
                          prefix: SelectCountry(
                            code: countryCode,
                            show: signIndex == 1,
                            onPressed: selectCountryCode,
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        AuthButton(
                          isSubmitting: isSubmitting,
                          isLogin: false,
                          onPressed: signup,
                          inputs: inputs,
                        ),
                        ToggleAuthScreen(
                          isLogin: false,
                          onChange: widget.onChange,
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [MyDivider(), LinkedAccountLogin()]),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class SelectCountry extends StatefulWidget {
  final Function() onPressed;
  final String code;
  final bool show;
  SelectCountry(
      {required this.code, required this.show, required this.onPressed});

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300), value: 0);

    animationController.animateTo(1);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        alignment: Alignment.centerLeft,
        firstChild: SizedBox(
          width: 100,
          height: 50,
          child: ScaleTransition(
            scale: animationController.view,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: widget.onPressed,
                child: Card(
                  elevation: 3,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  margin: EdgeInsets.fromLTRB(3, 2, 8, 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.code,
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w500),
                        ),
                        Icon(MyIcons.expand)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        secondChild: Container(width: 1, height: 1),
        crossFadeState:
            widget.show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 300));
  }
}

class SignupInfo {
  String? email;
  String? phone;

  String? get account => email ?? phone;

  SignupInfo({this.email, this.phone});
}

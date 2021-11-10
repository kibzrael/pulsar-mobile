import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/functions/time.dart';

class BirthdayPage extends StatefulWidget {
  @override
  _BirthdayPageState createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  late SignInfoProvider provider;

  String birthday = '';
  String age = '';

  DateTime selectedDate = DateTime.utc(DateTime.now().year - 13);

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SignInfoProvider>(context);

    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: SignInfoTitle(
            title: 'Birthday',
            onBack: provider.previousPage,
            onForward: () {
              provider.user.birthday = selectedDate;
              provider.nextPage();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(30),
          height: size,
          child: Column(
            children: [
              Text(
                'For personalized content. This info will be kept private',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 24),
              ),
              Spacer(
                flex: 2,
              ),

              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyText1!,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primaryVariant
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            birthday,
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(age),
                    )
                  ],
                ),
              ),

              // TextField(
              //   controller: textController,
              //   readOnly: true,
              //   decoration: InputDecoration(hintText: 'Birthday'),
              // ),
              Spacer(
                flex: 2,
              ),
              CupertinoTheme(
                data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness),
                child: Container(
                    height: 150,
                    child: CupertinoDatePicker(
                        maximumDate: DateTime.now(),
                        initialDateTime: selectedDate,
                        minimumYear: DateTime.now().year - 100,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime date) {
                          setState(() {
                            birthday = timeBirthday(date)['birthday']!;
                            age = timeBirthday(date)['age']!;
                            selectedDate = date;
                          });
                        })),
              ),
              Spacer(
                flex: 1,
              ),
              SizedBox(height: kToolbarHeight)
            ],
          ),
        )),
      ),
    );
  }
}

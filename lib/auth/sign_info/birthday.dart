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

  late TextEditingController textController;

  DateTime selectedDate = DateTime.utc(DateTime.now().year - 13);

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

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
                'Provide your birthday for better and personalized content. This information will be kept private',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(
                flex: 2,
              ),
              TextField(
                controller: textController,
                readOnly: true,
                decoration: InputDecoration(hintText: 'Birthday'),
              ),
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
                            textController.text = timeBirthday(date);
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

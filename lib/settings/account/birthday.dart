import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/providers/theme_provider.dart';

class EditBirthday extends StatefulWidget {
  const EditBirthday({Key? key}) : super(key: key);

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {

  String birthday = 'Date';
  String age = 'Age';

  DateTime selectedDate = DateTime.utc(DateTime.now().year - 13);

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(appBar: AppBar(title: const Text('Birthday')),
    
    body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(30),
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
              const Spacer(
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
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              gradient: primaryGradient(),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            birthday,
                            style: const TextStyle(color: Colors.white),
                          )),
                    ),
                    Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
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
              const Spacer(
                flex: 2,
              ),
              CupertinoTheme(
                data: CupertinoThemeData(
                    brightness: Theme.of(context).brightness),
                child: SizedBox(
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
              const Spacer(
                flex: 1,
              ),
              const SizedBox(height: kToolbarHeight)
            ],
          ),
        )),
    );
  }
}

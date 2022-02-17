import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditBirthday extends StatefulWidget {
  final DateTime? initialDate;

  const EditBirthday({Key? key, required this.initialDate}) : super(key: key);

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {
  String birthday = 'Date';
  String age = 'Age';

  bool isEdited = false;

  // check from user's current birthday
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate ?? DateTime.utc(DateTime.now().year - 13);
    if (widget.initialDate != null) {
      birthday = timeBirthday(selectedDate)['birthday']!;
      age = timeBirthday(selectedDate)['age']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MyIcons.back),
          onPressed: () {
            if (isEdited) {
              openDialog(
                      context,
                      (context) => const MyDialog(
                            title: 'Caution!',
                            body:
                                'The changes you\'ve made would be lost if you quit.',
                            actions: ['Cancel', 'Ok'],
                            destructive: 'Ok',
                          ),
                      dismissible: true)
                  .then((value) {
                if (value == 'Ok') {
                  Navigator.pop(context);
                }
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Birthday'),
        actions: [
          MyTextButton(
              text: 'Done',
              onPressed: () {
                DateTime date = selectedDate;
                Navigator.pop(
                    context, isEdited ? date.toString().split(' ')[0] : null);
              })
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(30),
        height: size,
        child: Column(
          children: [
            Text(
              'For personalized content. This info will be kept private',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),
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
                        color: Theme.of(context).inputDecorationTheme.fillColor,
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
              data:
                  CupertinoThemeData(brightness: Theme.of(context).brightness),
              child: SizedBox(
                  height: 150,
                  child: CupertinoDatePicker(
                      maximumDate: DateTime.now(),
                      initialDateTime: selectedDate,
                      minimumYear: DateTime.now().year - 100,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime date) {
                        setState(() {
                          isEdited = true;
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

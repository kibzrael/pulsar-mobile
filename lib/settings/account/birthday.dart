import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/secondary_pages.dart/select_birthday.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditBirthday extends StatefulWidget {
  final DateTime? initialDate;

  const EditBirthday({Key? key, required this.initialDate}) : super(key: key);

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {
  bool isEdited = false;

  // check from user's current birthday
  late DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
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
        body: SelectBirthday(
            initialDate: widget.initialDate,
            onSelected: (date) {
              setState(() {
                isEdited = true;
                selectedDate = date;
              });
            }));
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/dialog.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_birthday.dart';
import 'package:pulsar/widgets/dialog.dart';
import 'package:pulsar/widgets/text_button.dart';

class EditBirthday extends StatefulWidget {
  final DateTime? initialDate;

  const EditBirthday({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<EditBirthday> createState() => _EditBirthdayState();
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
                        (context) => MyDialog(
                              title: local(context).caution,
                              body: local(context).loseChangesWarning,
                              actions: [
                                local(context).cancel,
                                local(context).ok
                              ],
                              destructive: local(context).ok,
                            ),
                        dismissible: true)
                    .then((value) {
                  if (value == local(context).ok) {
                    Navigator.pop(context);
                  }
                });
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(local(context).birthday),
          actions: [
            MyTextButton(
                text: local(context).done,
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

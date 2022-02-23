import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/functions/time.dart';
import 'package:pulsar/providers/theme_provider.dart';

class SelectBirthday extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime date) onSelected;
  const SelectBirthday(
      {Key? key, required this.initialDate, required this.onSelected})
      : super(key: key);

  @override
  _SelectBirthdayState createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String birthday = 'Date';
  String age = 'Age';

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
    super.build(context);
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(30),
        height: constraints.maxHeight,
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
                          widget.onSelected(date);
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
      ));
    });
  }
}

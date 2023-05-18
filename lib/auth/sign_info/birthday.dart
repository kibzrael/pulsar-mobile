import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/auth/sign_info/sign_info.dart';
import 'package:pulsar/auth/sign_info/sign_info_provider.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/secondary_pages.dart/select_birthday.dart';

class BirthdayPage extends StatefulWidget {
  const BirthdayPage({Key? key}) : super(key: key);

  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late SignInfoProvider provider;

  DateTime selectedDate = DateTime.utc(DateTime.now().year - 13);

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<SignInfoProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: signInfoAppBar(context,
              title: local(context).birthday,
              onBack: provider.previousPage, onForward: () {
            if (selected) provider.user.birthday = selectedDate;
            provider.nextPage();
          }),
          body: SelectBirthday(
              initialDate: provider.user.birthday,
              onSelected: (date) {
                setState(() {
                  selected = true;
                  selectedDate = date;
                });
              })),
    );
  }
}

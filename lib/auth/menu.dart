import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/settings/blank.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/settings/theme.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';

class AuthMenu extends StatelessWidget {
  const AuthMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // language, theme, terms of use, policies
    return MyBottomSheet(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  MyListTile(
                    title: 'Language',
                    leading: Icon(MyIcons.language),
                    onPressed: () {
                      Navigator.of(context).push(
                          myPageRoute(builder: (context) => const Language()));
                    },
                  ),
                  MyListTile(
                    title: 'Theme',
                    leading: Icon(MyIcons.theme),
                    onPressed: () {
                      Navigator.of(context).push(myPageRoute(
                          builder: (context) => const SelectTheme()));
                    },
                  ),
                  MyListTile(
                    title: 'Terms of use',
                    leading: Icon(MyIcons.terms),
                    onPressed: () {
                      Navigator.of(context).push(
                          myPageRoute(builder: (context) => const Blank()));
                    },
                  ),
                  MyListTile(
                    title: 'Privacy Policy',
                    leading: Icon(MyIcons.policies),
                    onPressed: () {
                      Navigator.of(context).push(
                          myPageRoute(builder: (context) => const Blank()));
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

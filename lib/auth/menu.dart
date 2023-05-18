import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/settings/policies/privacy_policy.dart';
import 'package:pulsar/settings/policies/terms_of_use.dart';
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
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shrinkWrap: true,
        children: [
          MyListTile(
            title: local(context).language,
            leading: Icon(MyIcons.language),
            onPressed: () {
              Navigator.of(context)
                  .push(myPageRoute(builder: (context) => const Language()));
            },
          ),
          MyListTile(
            title: local(context).theme,
            leading: Icon(MyIcons.theme),
            onPressed: () {
              Navigator.of(context)
                  .push(myPageRoute(builder: (context) => const SelectTheme()));
            },
          ),
          MyListTile(
            title: local(context).termsOfUse,
            leading: Icon(MyIcons.terms),
            onPressed: () {
              Navigator.of(context)
                  .push(myPageRoute(builder: (context) => const TermsOfUse()));
            },
          ),
          MyListTile(
            title: local(context).privacyPolicy,
            leading: Icon(MyIcons.policies),
            onPressed: () {
              Navigator.of(context).push(
                  myPageRoute(builder: (context) => const PrivacyPolicy()));
            },
          )
        ],
      ),
    );
  }
}

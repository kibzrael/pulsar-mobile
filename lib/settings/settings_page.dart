import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/settings/account/manage_account.dart';
import 'package:pulsar/settings/billing.dart';
import 'package:pulsar/settings/blank.dart';
import 'package:pulsar/settings/cache.dart';
import 'package:pulsar/settings/data_saver.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/settings/log_out.dart';
import 'package:pulsar/settings/privacy/privacy.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/settings/theme.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, Map<String, Map<String, dynamic>>> settings = {
    'Account': {
      'Manage Account': {'icon': MyIcons.account, 'page': ManageAccount()},
      'Billing': {'icon': MyIcons.billing, 'page': Billing()},
    },

    // 'Ads': {
    //   'Ad activity': {'icon': MyIcons.activity, 'page': null},
    //   'About Ads': {'icon': MyIcons.ad, 'page': null},
    // },

    'Display & Media': {
      'Data Saver': {'icon': MyIcons.dataSaver, 'page': DataSaver()},
      'Theme': {'icon': MyIcons.theme, 'page': SelectTheme()},
      'Language': {'icon': MyIcons.language, 'page': Language()},
    },
    'Support': {
      'Privacy': {'icon': MyIcons.privacy, 'page': Privacy()},
      'Report': {'icon': MyIcons.report, 'page': ReportScreen()},
    },
    'About': {
      'Terms of use': {'icon': MyIcons.terms, 'page': null},
      'Policies': {'icon': MyIcons.policies, 'page': null},
    }
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(children: <Widget>[
          for (String key in settings.keys.toList())
            Section(
              title: key,
              titleSize: 18,
              child: Column(
                children: [
                  for (String subKey in settings[key]!.keys.toList())
                    Column(
                      children: [
                        MyListTile(
                          onPressed: () {
                            Navigator.of(context).push(myPageRoute(
                                builder: (context) =>
                                    settings[key]![subKey]!['page'] ??
                                    Blank()));
                          },
                          title: subKey,
                          leading: Icon(
                            settings[key]![subKey]!['icon'],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(
                            thickness: 1.2,
                          ),
                        )
                      ],
                    )
                ],
              ),
            ),
          Cache(),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Column(
                  children: [
                    LogOut(),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.only(bottom: 15),
                        alignment: Alignment.center,
                        child: Text('V1.0.0'))
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}

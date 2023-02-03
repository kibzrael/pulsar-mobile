import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/settings/account/manage_account.dart';
import 'package:pulsar/settings/admin/root.dart';
import 'package:pulsar/settings/billing.dart';
import 'package:pulsar/settings/blank.dart';
import 'package:pulsar/settings/cache.dart';
import 'package:pulsar/settings/data_saver.dart';
import 'package:pulsar/settings/drafts.dart';
import 'package:pulsar/settings/language.dart';
import 'package:pulsar/settings/log_out.dart';
import 'package:pulsar/settings/policies/privacy_policy.dart';
import 'package:pulsar/settings/policies/terms_of_use.dart';
import 'package:pulsar/settings/privacy/privacy.dart';
import 'package:pulsar/settings/report/report.dart';
import 'package:pulsar/settings/theme.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, Map<String, Map<String, dynamic>>> settings = {
    'Account': {
      'Manage Account': {
        'icon': MyIcons.account,
        'page': const ManageAccount()
      },
      'Billing': {'icon': MyIcons.billing, 'page': const Billing()},
    },

    // 'Ads': {
    //   'Ad activity': {'icon': MyIcons.activity, 'page': null},
    //   'About Ads': {'icon': MyIcons.ad, 'page': null},
    // },

    'Display & Media': {
      'Data Saver': {'icon': MyIcons.dataSaver, 'page': const DataSaver()},
      'Drafts': {'icon': MyIcons.drafts, 'page': const Drafts()},
      'Theme': {'icon': MyIcons.theme, 'page': const SelectTheme()},
      'Language': {'icon': MyIcons.language, 'page': const Language()},
    },
    'Support': {
      'Privacy': {'icon': MyIcons.privacy, 'page': const Privacy()},
      'Report': {'icon': MyIcons.report, 'page': const ReportScreen()},
      'Admin Panel': {'icon': MyIcons.tune, 'page': const PulsarAdmin()},
    },
    'About': {
      'Terms of use': {'icon': MyIcons.terms, 'page': const TermsOfUse()},
      'Policies': {'icon': MyIcons.policies, 'page': const PrivacyPolicy()},
    }
  };
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(children: <Widget>[
          for (String key in settings.keys.toList())
            Section(
              title: key,
              titleSize: 18,
              child: Column(
                children: [
                  for (String subKey in settings[key]!.keys.toList())
                    if (!userProvider.user.isSuperuser &&
                        subKey == 'Admin Panel')
                      Container()
                    else
                      Column(
                        children: [
                          MyListTile(
                            onPressed: () {
                              Navigator.of(context).push(myPageRoute(
                                  builder: (context) =>
                                      settings[key]![subKey]!['page'] ??
                                      const Blank()));
                            },
                            title: subKey,
                            leading: Icon(
                              settings[key]![subKey]!['icon'],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              thickness: 1,
                            ),
                          )
                        ],
                      )
                ],
              ),
            ),
          const Cache(),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                Column(
                  children: [
                    const LogOut(),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.only(bottom: 15),
                        alignment: Alignment.center,
                        child: const Text('V1.0.0'))
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}

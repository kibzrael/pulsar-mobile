import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/providers/localization_provider.dart';
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
  late Map<String, Map<String, Map<String, dynamic>>> settings;

  @override
  void didChangeDependencies() {
    settings = {
      local(context).account: {
        local(context).manageAccount: {
          'icon': MyIcons.account,
          'page': const ManageAccount()
        },
        local(context).billing: {
          'icon': MyIcons.billing,
          'page': const Billing()
        },
      },

      // 'Ads': {
      //   'Ad activity': {'icon': MyIcons.activity, 'page': null},
      //   'About Ads': {'icon': MyIcons.ad, 'page': null},
      // },

      local(context).displayAndMedia: {
        local(context).dataSaver: {
          'icon': MyIcons.dataSaver,
          'page': const DataSaver()
        },
        local(context).drafts: {'icon': MyIcons.drafts, 'page': const Drafts()},
        local(context).theme: {
          'icon': MyIcons.theme,
          'page': const SelectTheme()
        },
        local(context).language: {
          'icon': MyIcons.language,
          'page': const Language()
        },
      },
      local(context).support: {
        local(context).privacy: {
          'icon': MyIcons.privacy,
          'page': const Privacy()
        },
        local(context).report: {
          'icon': MyIcons.report,
          'page': const ReportScreen()
        },
        'Admin Panel': {'icon': MyIcons.tune, 'page': const PulsarAdmin()},
      },
      'About': {
        local(context).termsOfUse: {
          'icon': MyIcons.terms,
          'page': const TermsOfUse()
        },
        local(context).policies: {
          'icon': MyIcons.policies,
          'page': const PrivacyPolicy()
        },
      }
    };
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(local(context).settings),
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

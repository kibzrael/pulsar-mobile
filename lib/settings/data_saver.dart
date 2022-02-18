import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/settings_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/option_tile.dart';
import 'package:pulsar/widgets/section.dart';

class DataSaver extends StatefulWidget {
  const DataSaver({Key? key}) : super(key: key);

  @override
  _DataSaverState createState() => _DataSaverState();
}

class _DataSaverState extends State<DataSaver> {
  late SettingsProvider provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Saver'),
      ),
      body: Column(
        children: [
          OptionTile(
            title: 'Save Data',
            subtitle:
                'This will prevent pre-loading of videos and leaving open connections to save on your data in case you are on cellular data.',
            trailingArrow: false,
            trailing: Switch.adaptive(
                value: provider.settings.dataSaver,
                onChanged: (bool value) {
                  provider.settings.dataSaver = value;
                  provider.save();
                }),
          ),
          OptionTile(
            title: 'Request timeout',
            subtitle:
                'This is the duration a connection is kept open in case there is slow connection or faulty connection.',
            trailingText: '${provider.settings.requestTimeout} sec',
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.only(top: 30),
              child: Section(
                title: 'Media Options',
                child: SingleChildScrollView(
                    child: Column(children: const [
                  MyListTile(
                    title: 'Media AutoPlay',
                    subtitle: 'On wi-fi only',
                  ),
                  MyListTile(
                    title: 'Media Quality',
                    subtitle: 'High',
                  )
                ])),
              ),
            ),
          )
        ],
      ),
    );
  }
}

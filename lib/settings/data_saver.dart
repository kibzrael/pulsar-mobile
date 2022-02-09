import 'package:flutter/material.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/option_tile.dart';
import 'package:pulsar/widgets/section.dart';

class DataSaver extends StatefulWidget {
  const DataSaver({Key? key}) : super(key: key);

  @override
  _DataSaverState createState() => _DataSaverState();
}

class _DataSaverState extends State<DataSaver> {
  bool saveData = false;
  @override
  Widget build(BuildContext context) {
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
                value: saveData,
                onChanged: (bool value) {
                  setState(() {
                    saveData = value;
                  });
                }),
          ),
          const OptionTile(
            title: 'Request timeout',
            subtitle:
                'This is the duration a connection is kept open in case there is slow connection or faulty connection.',
            trailingText: '15 sec',
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

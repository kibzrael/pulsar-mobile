import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/settings.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/providers/settings_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/navigation_rail.dart';
import 'package:pulsar/widgets/option_tile.dart';
import 'package:pulsar/widgets/section.dart';

class DataSaver extends StatefulWidget {
  const DataSaver({Key? key}) : super(key: key);

  @override
  State<DataSaver> createState() => _DataSaverState();
}

class _DataSaverState extends State<DataSaver> {
  late SettingsProvider provider;
  late Settings settings;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingsProvider>(context);
    settings = provider.settings;
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
                    child: Column(children: [
                  MyListTile(
                    title: 'Media AutoPlay',
                    subtitle: mediaAutoplay[settings.mediaAutoplay]!,
                    onPressed: () async {
                      String? selected = await openBottomSheet(
                          context,
                          (context) => OptionsRail(
                              options: [...mediaAutoplay.values.toList()],
                              selected:
                                  mediaAutoplay[settings.mediaAutoplay]!));
                      if (selected != null) {
                        provider.settings.mediaAutoplay = mediaAutoplay.keys
                            .firstWhere((element) =>
                                mediaAutoplay[element] == selected);
                        provider.save();
                      }
                    },
                  ),
                  MyListTile(
                    title: 'Media Quality',
                    subtitle: mediaQuality[settings.mediaQuality]!,
                    onPressed: () async {
                      String? selected = await openBottomSheet(
                          context,
                          (context) => OptionsRail(
                              options: [...mediaQuality.values.toList()],
                              selected: mediaQuality[settings.mediaQuality]!));
                      if (selected != null) {
                        provider.settings.mediaQuality = mediaQuality.keys
                            .firstWhere(
                                (element) => mediaQuality[element] == selected);
                        provider.save();
                      }
                    },
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

Map<Autoplay, String> mediaAutoplay = {
  Autoplay.alwaysOn: 'Always on',
  Autoplay.wifiOnly: 'On wi-fi only',
  Autoplay.off: 'Always off',
};

Map<MediaQuality, String> mediaQuality = {
  MediaQuality.auto: 'Automatic',
  MediaQuality.low: 'Low',
  MediaQuality.medium: 'Medium',
  MediaQuality.high: 'High',
};

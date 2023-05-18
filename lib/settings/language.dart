import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/widgets/list_tile.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  late LocalizationProvider provider;

  List<String> flags = ['🇬🇧', '🇰🇪'];

  Map<String, String> languages = {
    'en': 'English',
    'sw': 'Swahili',
  };

  late String language;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<LocalizationProvider>(context, listen: false);
    language = provider.locale.languageCode;
  }

  void languageSwitch(int index) {
    setState(() {
      language = languages.keys.elementAt(index);
      provider.setLocale(Locale(language));
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LocalizationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local(context).language),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return MyListTile(
            title: languages.values.elementAt(index),
            leading: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(flags[index],
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            onPressed: () => languageSwitch(index),
            trailingArrow: false,
            trailing: Radio<String>(
                value: languages.keys.elementAt(index),
                groupValue: language,
                onChanged: (value) => languageSwitch(index)),
          );
        },
      ),
    );
  }
}

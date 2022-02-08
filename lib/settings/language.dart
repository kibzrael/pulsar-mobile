import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  List<String> languages = [
    'English',
    'French',
    'German',
    'Indian',
    'Italian',
    'Spanish',
  ];
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return MyListTile(
            title: languages[index],
            leading: Icon(
              MyIcons.language,
              color: Theme.of(context).textTheme.subtitle2!.color,
            ),
            onPressed: () {
              setState(() {
                language = languages[index];
              });
            },
            trailingArrow: false,
            trailing: languages[index] == language ? Icon(MyIcons.check) : null,
          );
        },
      ),
    );
  }
}

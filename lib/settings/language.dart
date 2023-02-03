import 'package:flutter/material.dart';
import 'package:pulsar/placeholders/not_implemented.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
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
          title: const Text('Select Language'),
        ),
        body: const NotImplementedError()
        //  ListView.builder(
        //   itemCount: languages.length,
        //   shrinkWrap: true,
        //   itemBuilder: (context, index) {
        //     return MyListTile(
        //       title: languages[index],
        //       leading: Icon(
        //         MyIcons.language,
        //         color: Theme.of(context).textTheme.titleSmall!.color,
        //       ),
        //       onPressed: () {
        //         setState(() {
        //           language = languages[index];
        //         });
        //       },
        //       trailingArrow: false,
        //       trailing: languages[index] == language ? Icon(MyIcons.check) : null,
        //     );
        //   },
        // ),
        );
  }
}

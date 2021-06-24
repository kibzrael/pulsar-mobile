import 'package:flutter/material.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';

class SearchMessages extends StatefulWidget {
  const SearchMessages({Key? key}) : super(key: key);

  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      titleSpacing: 0.0,
      title: Hero(
        tag: 'searchMessages',
        child: SearchField(
          onChanged: (text) {},
          onSubmitted: (text) {},
          hintText: 'Search Messages...',
          autofocus: true,
        ),
      ),
      actions: [MyTextButton(text: 'Search', onPressed: () {})],
    ));
  }
}

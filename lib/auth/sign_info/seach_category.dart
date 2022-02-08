import 'package:flutter/material.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';

class SearchCategory extends StatefulWidget {
  @override
  _SearchCategoryState createState() => _SearchCategoryState();
}

class _SearchCategoryState extends State<SearchCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Hero(
          tag: 'searchCategory',
          child: SearchField(
            onChanged: (text) {},
            onSubmitted: (text) {},
            hintText: 'Search Categories...',
            autofocus: true,
          ),
        ),
        actions: [MyTextButton(text: 'Search', onPressed: () {})],
      ),
    );
  }
}

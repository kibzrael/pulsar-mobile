import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  const SearchSuggestions(this.suggestions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return MyListTile(
          title: suggestions[index],
          leading: const Icon(Icons.history),
          trailing: Icon(MyIcons.searchHistory),
          trailingArrow: false,
        );
      },
    );
  }
}

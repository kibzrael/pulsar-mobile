import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class SearchSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String text) onSearch;
  final Function(String text) onSelect;
  const SearchSuggestions(this.suggestions,
      {Key? key, required this.onSearch, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return MyListTile(
          title: suggestions[index],
          leading: Icon(MyIcons.history),
          trailing: InkWell(
              onTap: () {
                onSelect(suggestions[index]);
              },
              child: Icon(MyIcons.searchHistory)),
          trailingArrow: false,
          onPressed: () => onSearch(suggestions[index]),
        );
      },
    );
  }
}

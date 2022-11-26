import 'package:flutter/material.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/search_field.dart';
import 'package:pulsar/widgets/text_button.dart';

class SearchCategory extends StatefulWidget {
  final List<Interest> interests;
  const SearchCategory(this.interests, {Key? key}) : super(key: key);

  @override
  _SearchCategoryState createState() => _SearchCategoryState();
}

class _SearchCategoryState extends State<SearchCategory> {
  List<Interest> results = [];

  String keyword = '';

  @override
  Widget build(BuildContext context) {
    RegExp pattern = RegExp(keyword, caseSensitive: false);
    results = [
      ...widget.interests.where((e) => (e.name.contains(pattern) |
              e.user.contains(pattern) |
              (e.users?.contains(pattern) ?? false) &&
          keyword != ''))
    ];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: SearchField(
          onChanged: (text) => setState(() => keyword = text),
          onSubmitted: (text) {},
          hintText: 'Search Categories...',
          autofocus: true,
        ),
        actions: [MyTextButton(text: 'Search', onPressed: () {})],
      ),
      body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            Interest interest = results[index];
            return MyListTile(
              title: interest.user,
              onPressed: () => Navigator.pop(context, interest),
              leading: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(interest.cover!.medium ??
                            interest.cover!.thumbnail))),
              ),
            );
          }),
    );
  }
}

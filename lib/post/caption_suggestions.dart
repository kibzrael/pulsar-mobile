import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/post.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/progress_indicator.dart';

class CaptionSuggestions extends StatefulWidget {
  final String keyword;
  final CaptionSuggestion type;
  final Function(String text) onSelect;
  const CaptionSuggestions(this.keyword,
      {Key? key, required this.type, required this.onSelect})
      : super(key: key);

  @override
  State<CaptionSuggestions> createState() => _CaptionSuggestionsState();
}

class _CaptionSuggestionsState extends State<CaptionSuggestions> {
  late UserProvider userProvider;
  List<Map<String, dynamic>> results = [];

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.initState();
    search();
  }

  @override
  void didUpdateWidget(CaptionSuggestions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keyword != widget.keyword) {
      search();
    }
  }

  search() async {
    results.clear();
    if (mounted) setState(() {});
    String url;
    if (widget.type == CaptionSuggestion.mentions) {
      url = getUrl(UserUrls.search(widget.keyword.trim(), 0));
    } else {
      url = getUrl(PostUrls.searchTags(widget.keyword.trim(), 0));
    }

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      results = [...List<Map<String, dynamic>>.from(body['results'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.symmetric(
              horizontal:
                  BorderSide(color: Theme.of(context).dividerColor, width: 2))),
      child: results.isEmpty
          ? const MyProgressIndicator()
          : ListView.builder(
              itemCount: results.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (widget.type == CaptionSuggestion.mentions) {
                  User user = User.fromJson(results[index]);
                  return UserCard(user,
                      trailing: false,
                      onPressed: () => widget.onSelect(user.username));
                } else {
                  return MyListTile(
                      title: "#${results[index]['tag']}",
                      onPressed: () => widget.onSelect(results[index]['tag']));
                }
              }),
    );
  }
}

enum CaptionSuggestion { tags, mentions }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/models/posts_view.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/home.dart';

class FollowingPosts extends StatefulWidget {
  const FollowingPosts({Key? key}) : super(key: key);

  @override
  State<FollowingPosts> createState() => _FollowingPostsState();
}

class _FollowingPostsState extends State<FollowingPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late UserProvider userProvider;

  Future<List<Map<String, dynamic>>> fetchData(int index) async {
    List<Map<String, dynamic>> result = [];
    String url = getUrl(HomeUrls.feed(index));

    http.Response response = await http.get(Uri.parse(url),
        headers: {"Authorization": userProvider.user.token ?? ""});

    var responseData = jsonDecode(response.body);

    if (responseData is Map) {
      result = [...responseData['posts']];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    return PostsView(target: fetchData);

    // const DiscoverUsers();
  }
}

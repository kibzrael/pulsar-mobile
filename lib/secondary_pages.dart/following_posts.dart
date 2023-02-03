import 'package:flutter/material.dart';
import 'package:pulsar/models/discover_users.dart';

class FollowingPosts extends StatefulWidget {
  const FollowingPosts({Key? key}) : super(key: key);

  @override
  State<FollowingPosts> createState() => _FollowingPostsState();
}

class _FollowingPostsState extends State<FollowingPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const DiscoverUsers();
  }
}

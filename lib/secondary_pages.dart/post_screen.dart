import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/models/posts_view.dart';
import 'package:pulsar/options/post_options.dart';
import 'package:pulsar/providers/theme_provider.dart';

class PostScreen extends StatefulWidget {
  final List<Post> initialPosts;
  final int postInView;

  PostScreen(
      {required this.initialPosts, // = const [],
      this.postInView = 0});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  void moreOnPost() {
    openBottomSheet(context,
        (context) => PostOptions(widget.initialPosts[widget.postInView]));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent, actions: [
          IconButton(icon: Icon(MyIcons.more), onPressed: moreOnPost)
        ]),
        body: PostsView(
          initialPosts: widget.initialPosts,
          postInView: widget.postInView,
        ),
      ),
    );
  }
}

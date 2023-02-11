import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/models/posts_view.dart';
import 'package:pulsar/providers/theme_provider.dart';

class PostScreen extends StatefulWidget {
  final List<Post> initialPosts;
  final int initialIndex;
  final int postInView;
  final String title;
  final Future<List<Map<String, dynamic>>> Function(int index) target;

  const PostScreen(
      {Key? key,
      required this.initialPosts,
      required this.target, // = const [],
      required this.title,
      this.initialIndex = 0,
      this.postInView = 0})
      : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: PostsView(
            initialPosts: widget.initialPosts,
            initialIndex: widget.initialIndex,
            postInView: widget.postInView,
            target: widget.target),
      ),
    );
  }
}

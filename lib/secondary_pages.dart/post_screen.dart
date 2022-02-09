import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/models/posts_view.dart';
import 'package:pulsar/providers/theme_provider.dart';

class PostScreen extends StatefulWidget {
  final List<Post> initialPosts;
  final int postInView;
  final String title;

  const PostScreen(
      {Key? key, required this.initialPosts, // = const [],
      required this.title,
      this.postInView = 0}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
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
            actions: [
              Opacity(
                  opacity: 0,
                  child: IconButton(icon: Icon(MyIcons.more), onPressed: () {}))
            ]),
        body: PostsView(
          initialPosts: widget.initialPosts,
          postInView: widget.postInView,
        ),
      ),
    );
  }
}

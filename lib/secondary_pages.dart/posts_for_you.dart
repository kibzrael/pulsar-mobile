import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/models/posts_view.dart';

class PostsForYou extends StatefulWidget {
  final CarouselController controller;

  PostsForYou({required this.controller});

  @override
  _PostsForYouState createState() => _PostsForYouState();
}

class _PostsForYouState extends State<PostsForYou>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Post> posts = [...allPosts];

  @override
  void initState() {
    super.initState();
    posts.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PostsView(initialPosts: posts, controller: widget.controller);
  }
}

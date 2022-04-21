import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/models/post_layout.dart';
import 'package:pulsar/providers/theme_provider.dart';

class PostsView extends StatefulWidget {
  final List<Post> initialPosts;
  final int postInView;
  final CarouselController? controller;
  final Future<List<Map<String, dynamic>>> Function(int index) target;

  const PostsView(
      {Key? key,
      this.initialPosts = const [],
      required this.target,
      this.postInView = 0,
      this.controller})
      : super(key: key);

  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  late List<Post> posts;
  int initialPage = 0;

  late int pageIndex;

  @override
  void initState() {
    super.initState();
    posts = widget.initialPosts;
    initialPage = posts.length > widget.postInView ? widget.postInView : 0;
    pageIndex = initialPage;
  }

  Future<bool> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement recyclerview on posts_view
    return LayoutBuilder(builder: (context, constraints) {
      double aspectRatio = constraints.maxWidth / constraints.maxHeight;
      bool stretch = aspectRatio > 0.5;
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: RefreshIndicator(
              onRefresh: onRefresh,
              displacement: (kToolbarHeight - 21) +
                  Provider.of<ThemeProvider>(context, listen: false).topPadding,
              child: CarouselSlider.builder(
                  itemCount: posts.length,
                  carouselController: widget.controller,
                  itemBuilder: (context, index, _) {
                    return PostLayout(
                      posts[index],
                      isInView: pageIndex == index,
                      stretch: stretch,
                      onDelete: () {
                        setState(() {
                          posts.removeAt(index);
                        });
                      },
                    );
                  },
                  options: CarouselOptions(
                      height: constraints.maxHeight -
                          (stretch ? 0 : (kToolbarHeight)),
                      scrollDirection: Axis.vertical,
                      viewportFraction: 1,
                      initialPage: initialPage,
                      onPageChanged: (index, _) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      enableInfiniteScroll: false)),
            ),
          ),
          // Column(
          //   children: [
          //     Spacer(),
          //     SizedBox(
          //       height: 2,
          //     ),
          //     VideoProgress(),
          //     SizedBox(height: kToolbarHeight - 2.5)
          //   ],
          // )
        ],
      );
    });
  }
}

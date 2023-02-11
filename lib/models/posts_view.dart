import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/models/post_layout.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class PostsView extends StatefulWidget {
  final List<Post> initialPosts;
  final int initialIndex;
  final int postInView;
  final CarouselController? controller;
  final Future<List<Map<String, dynamic>>> Function(int index) target;
  final Widget? noData;

  const PostsView(
      {Key? key,
      this.initialPosts = const [],
      this.initialIndex = 0,
      required this.target,
      this.postInView = 0,
      this.controller,
      this.noData})
      : super(key: key);

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  int initialPage = 0;

  late int pageIndex;

  @override
  void initState() {
    super.initState();
    initialPage =
        widget.initialPosts.length > widget.postInView ? widget.postInView : 0;
    pageIndex = initialPage;
  }

  Future<bool> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RecyclerView(
        target: widget.target,
        initialData: [...widget.initialPosts.map((e) => e.toJson())],
        initialIndex: widget.initialIndex,
        itemBuilder: (context, snapshot) {
          List<Map<String, dynamic>> snapshotData = snapshot.data;
          List<Post> posts = [...snapshotData.map((e) => Post.fromJson(e))];
          return snapshotData.isEmpty
              ? snapshot.isLoading ?? true
                  ? const Center(
                      child: MyProgressIndicator(),
                    )
                  : snapshot.errorLoading
                      ? snapshot.noData
                          ? widget.noData ?? const NoPosts()
                          : NetworkError(onRetry: snapshot.refreshCallback)
                      : Container()
              : LayoutBuilder(builder: (context, constraints) {
                  double aspectRatio =
                      constraints.maxWidth / constraints.maxHeight;
                  bool stretch = aspectRatio > 0.5;
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: RefreshIndicator(
                          onRefresh: onRefresh,
                          displacement: (kToolbarHeight - 21) +
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .topPadding,
                          child: CarouselSlider.builder(
                              itemCount: posts.length,
                              carouselController: widget.controller,
                              itemBuilder: (context, index, _) {
                                return PostLayout(
                                  posts[index],
                                  isInView: pageIndex == index,
                                  stretch: stretch,
                                  onDelete: () {
                                    posts.removeAt(index);
                                    Navigator.pop(context);
                                    setState(() {});
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
        });
  }
}

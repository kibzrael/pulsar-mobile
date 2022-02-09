import 'package:flutter/material.dart';

class UserBlogPosts extends StatefulWidget {
  const UserBlogPosts({Key? key}) : super(key: key);

  @override
  _UserBlogPostsState createState() => _UserBlogPostsState();
}

class _UserBlogPostsState extends State<UserBlogPosts>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = true;
  bool errorLoading = false;

  List<String> posts = [];

  fetchPosts() async {
    //
    // create a common getPosts function
    // for grid posts, reposts and saved posts
    await Future.delayed(const Duration(seconds: 2));

    List<String> _posts = [
      'assets/capture15.JPG',
      'assets/images (14).jpeg',
      'assets/images.jpg',
      'assets/images (15).jpeg',
      'assets/capture32.JPG',
      'assets/images (16).jpeg',
      'assets/images (12).jpg',
      'assets/images (17).jpeg',
      'assets/images (13).jpg',
      'assets/images (18).jpeg',
      'assets/capture8.JPG',
      'assets/images (19).jpeg',
      'assets/capture16.JPG',
      'assets/images (20).jpeg',
      'assets/capture20.JPG',
      'assets/images (21).jpeg',
      'assets/capture24.JPG',
      'assets/images (22).jpeg',
      'assets/capture25.JPG',
      'assets/images (7).jpeg',
      'assets/capture23.JPG',
      'assets/images (8).jpeg',
    ];
    // use this method just within the future for lazy loading
    if (mounted) {
      setState(() {
        posts = [...posts, ..._posts];
        isLoading = false;
        // errorLoading = true;
      });
    }
  }

  onRetry() async {
    setState(() {
      // make isLoading true when posts are empty
      isLoading = true;
      errorLoading = false;
      fetchPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    //
    // if initial data
    // change isLoading to false
    //
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        // color: Theme.of(context).brightness == Brightness.dark
        //     ? Colors.grey.withOpacity(0.05)
        //     : Colors.grey[50],
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        constraints: const BoxConstraints(minHeight: 100),
        child: GridView.builder(
            itemCount: posts.length,
            //padding: EdgeInsets.only(bottom: bottomPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.75,
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3)));
            }));
  }
}

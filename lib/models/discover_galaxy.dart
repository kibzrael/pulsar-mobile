import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/post.dart';
import 'package:pulsar/data/posts.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/post_screen.dart';

class DiscoverGalaxy extends StatefulWidget {
  @override
  _DiscoverGalaxyState createState() => _DiscoverGalaxyState();
}

class _DiscoverGalaxyState extends State<DiscoverGalaxy> {
  List<Post> posts = allPosts;

  @override
  void initState() {
    super.initState();
    posts.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      constraints: BoxConstraints(minHeight: 100),
      child: GridView.builder(
          itemCount: posts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (context, index) {
            Post post = posts[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    settings: RouteSettings(name: 'postView'),
                    builder: (context) => PostScreen(
                          initialPosts: posts,
                          postInView: index,
                        )));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  fit: StackFit.loose,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          image: DecorationImage(
                              image: AssetImage(post.video.thumbnail),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Theme(
                      data: darkTheme,
                      child: Builder(builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.bottomCenter,
                          height: 50,
                          color: Colors.black26,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: theme.dividerColor,
                                radius: 18,
                                backgroundImage:
                                    AssetImage(post.user.profilePic),
                              ),
                              SizedBox(width: 2.5),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('@${post.user.username}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(fontSize: 13)),
                                  Text('${post.user.category}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontSize: 12,
                                              color: Colors.white))
                                ],
                              )),
                              SizedBox(width: 2.5),
                              Icon(MyIcons.play, size: 18),
                              Text('2.4K',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          fontSize: 12, color: Colors.white))
                            ],
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

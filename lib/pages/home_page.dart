import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/discover_posts.dart';
import 'package:pulsar/secondary_pages.dart/following_posts.dart';
import 'package:pulsar/widgets/route.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(0, () => key);
    return Scaffold(
        body: Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 0)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings, builder: (context) => RootHomePage());
      },
    ));
  }
}

class RootHomePage extends StatefulWidget {
  @override
  _RootHomePageState createState() => _RootHomePageState();
}

class _RootHomePageState extends State<RootHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late CarouselController followingController;
  late CarouselController forYouController;

  int pageIndex = 1;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: pageIndex);

    followingController = CarouselController();
    forYouController = CarouselController();
  }

  void onPageChanged(int index) {
    controller.jumpToPage(index);
    setState(() {
      pageIndex = index;
    });
  }

  // void moreOnPost() {
  //   openBottomSheet(context, (context) => PostOptions(lynn1));
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BasicRootProvider rootPageProvider =
        Provider.of<BasicRootProvider>(context, listen: false);

    rootPageProvider.pageScrollControllers.update(
        0, (value) => pageIndex == 0 ? followingController : forYouController,
        ifAbsent: () {
      rootPageProvider.pageScrollControllers.putIfAbsent(
          0, () => pageIndex == 0 ? followingController : forYouController);
    });

    return Theme(
      data: darkTheme,
      child: Builder(builder: (
        context,
      ) {
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0.0,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SegmentObject(
                      'Following',
                      0,
                      pageIndex: pageIndex,
                      onPressed: onPageChanged,
                    ),
                    Container(
                      width: 0.75,
                      height: 12,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.white54,
                    ),
                    SegmentObject(
                      'Discover',
                      1,
                      pageIndex: pageIndex,
                      onPressed: onPageChanged,
                    )
                  ],
                ),
              ),
            ),
            body: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FollowingPosts(),
                DiscoverPosts()
                // PostsForYou(controller: forYouController)
              ],
            ));
      }),
    );
  }
}

class SegmentObject extends StatefulWidget {
  final String text;
  final int index;

  final int pageIndex;
  final Function(int index) onPressed;

  SegmentObject(this.text, this.index,
      {required this.pageIndex, required this.onPressed});

  @override
  _SegmentObjectState createState() => _SegmentObjectState();
}

class _SegmentObjectState extends State<SegmentObject> {
  int? oldIndex;

  TextStyle active = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.5);

  TextStyle inactive = TextStyle(
      color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 16.5);

  @override
  Widget build(BuildContext context) {
    TextStyleTween tween = widget.index == widget.pageIndex
        ? TextStyleTween(begin: inactive, end: active)
        : TextStyleTween(begin: active, end: inactive);

    return Expanded(
      child: InkWell(
        onTap: () => widget.onPressed(widget.index),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            alignment: widget.index == 0
                ? Alignment.centerRight
                : Alignment.centerLeft,
            height: 37.5 - 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TweenAnimationBuilder<TextStyle>(
                  tween: tween,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  builder: (context, style, _) {
                    return Text(widget.text, maxLines: 1, style: style);
                  }),
            )),
      ),
    );
  }
}

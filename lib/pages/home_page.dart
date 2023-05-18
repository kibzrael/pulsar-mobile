import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/secondary_pages.dart/discover_posts.dart';
import 'package:pulsar/secondary_pages.dart/following_posts.dart';
import 'package:pulsar/widgets/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(0, () => key);
    return Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 0)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings, builder: (context) => const RootHomePage());
      },
    );
  }
}

class RootHomePage extends StatefulWidget {
  const RootHomePage({Key? key}) : super(key: key);

  @override
  State<RootHomePage> createState() => _RootHomePageState();
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SegmentObject(
                    local(context).following,
                    0,
                    pageIndex: pageIndex,
                    onPressed: onPageChanged,
                  ),
                  Container(
                    width: 0.75,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.white54,
                  ),
                  SegmentObject(
                    local(context).discover,
                    1,
                    pageIndex: pageIndex,
                    onPressed: onPageChanged,
                  )
                ],
              ),
            ),
            body: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
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

  const SegmentObject(this.text, this.index,
      {Key? key, required this.pageIndex, required this.onPressed})
      : super(key: key);

  @override
  State<SegmentObject> createState() => _SegmentObjectState();
}

class _SegmentObjectState extends State<SegmentObject> {
  int? oldIndex;

  TextStyle active = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18.5);

  TextStyle inactive = const TextStyle(
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            alignment: widget.index == 0
                ? Alignment.centerRight
                : Alignment.centerLeft,
            height: 37.5 - 4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TweenAnimationBuilder<TextStyle>(
                  tween: tween,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  builder: (context, style, _) {
                    return Text(widget.text, maxLines: 1, style: style);
                  }),
            )),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/notifications/notifications_page.dart';
import 'package:pulsar/pages/home_page.dart';
import 'package:pulsar/pages/challenges.dart';
import 'package:pulsar/pages/my_profile.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/providers/activity_provider.dart';
import 'package:pulsar/providers/background_operations.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/upload_progress.dart';

class BasicRoot extends StatefulWidget {
  const BasicRoot({Key? key}) : super(key: key);

  @override
  _BasicRootState createState() => _BasicRootState();
}

class _BasicRootState extends State<BasicRoot> {
  PageController? pageController;
  int currentIndex = 0;

  BasicRootProvider? basicRootProvider;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationChange(int index) {
    if (index == 2) {
      Navigator.of(context, rootNavigator: true)
          .push(myPageRoute(builder: (context) => const PostProcess()));
    } else {
      if (pageController!.page != index) {
        setState(() {
          pageController!.jumpToPage(index);
        });
      } else {
        if (basicRootProvider!.pageNavigators[index]!.currentState!.canPop()) {
          basicRootProvider!.pageNavigators[index]!.currentState
              ?.popUntil(ModalRoute.withName("/"));
        } else {
          dynamic pageController =
              basicRootProvider!.pageScrollControllers[index];

          if (pageController != null) {
            if (pageController is CarouselController) {
              // CarouselController controller = pageController;
              // controller.animateToPage(0,
              //     duration: Duration(seconds: 1), curve: Curves.ease);
            } else if (pageController!.hasClients) {
              pageController!.animateTo(0.0,
                  duration: const Duration(seconds: 1), curve: Curves.ease);
            }
          }
        }
      }
    }
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context).topPadding =
        MediaQuery.of(context).viewPadding.top;

    BackgroundOperations bgOperations =
        Provider.of<BackgroundOperations>(context);

    bool isUploadingPost = bgOperations.isUploadingPost;

    return WillPopScope(
      onWillPop: () async {
        bool response;
        if (basicRootProvider!.pageNavigators[currentIndex]!.currentState!
            .canPop()) {
          basicRootProvider!.pageNavigators[currentIndex]!.currentState?.pop();
          response = false;
        } else {
          response = true;
        }
        return response;
      },
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ActivityProvider>(
                create: (_) => ActivityProvider(context)),
            ChangeNotifierProvider<BasicRootProvider>(
                create: (_) => BasicRootProvider())
          ],
          builder: (context, child) {
            return Consumer<ActivityProvider>(
                builder: (context, provider, child) {
              return Consumer<BasicRootProvider>(
                  builder: (context, provider, child) {
                basicRootProvider = provider;
                Map<int, String> navigatorTop = provider.navigatorsTop;
                bool barTransparent() {
                  bool transparent = false;

                  if (navigatorTop[0] == '/' && currentIndex == 0) {
                    transparent = true;
                  }
                  navigatorTop.forEach((key, value) {
                    if (value == 'postView' && currentIndex == key) {
                      transparent = true;
                    }
                  });

                  return transparent;
                }

                bool barIsTransparent = barTransparent();

                // bool themeIsDark = barIsTransparent ||
                //     Theme.of(context).brightness == Brightness.dark;

                return Scaffold(
                  extendBody: true,
                  resizeToAvoidBottomInset: false,
                  body: PageView(
                    controller: pageController,
                    onPageChanged: onPageChanged,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const HomePage(),
                      const ChallengesPage(),
                      Container(),
                      // const MessageScreen(),
                      const NotificationsPage(),
                      const MyProfilePage(),
                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    elevation: barIsTransparent ? 0 : 16,
                    color: barIsTransparent
                        ? Colors.transparent
                        : Theme.of(context)
                            .bottomNavigationBarTheme
                            .backgroundColor,
                    child: SizedBox.fromSize(
                      size: Size(
                          MediaQuery.of(context).size.width,
                          kToolbarHeight +
                              (isUploadingPost ? kToolbarHeight : 0)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUploadingPost)
                            UploadProgress(bgOperations.uploadPost!,
                                barIsTransparent: barIsTransparent),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                NavigationBarItem(
                                  0,
                                  label: 'Home',
                                  selected: currentIndex,
                                  icon: MyIcons.homeOutline,
                                  activeIcon: MyIcons.home,
                                  onTap: navigationChange,
                                  barIsTransparent: barIsTransparent,
                                ),
                                NavigationBarItem(
                                  1,
                                  label: 'Challenges',
                                  selected: currentIndex,
                                  icon: MyIcons.exploreOutline,
                                  activeIcon: MyIcons.explore,
                                  onTap: navigationChange,
                                  barIsTransparent: barIsTransparent,
                                ),
                                InkWell(
                                  onTap: () => navigationChange(2),
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ((MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5) -
                                                  40) /
                                              2),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: accentGradient(),
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Icon(
                                          MyIcons.add,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                                // NavigationBarItem(
                                //   3,
                                //   label: 'Inbox',
                                //   selected: currentIndex,
                                //   iconSize: 24,
                                //   icon: MyIcons.messageOutline,
                                //   onTap: navigationChange,
                                //   barIsTransparent: barIsTransparent,
                                // ),
                                NavigationBarItem(
                                  3,
                                  label: 'Activity',
                                  selected: currentIndex,
                                  icon: MyIcons.notifications,
                                  onTap: navigationChange,
                                  barIsTransparent: barIsTransparent,
                                ),
                                NavigationBarItem(
                                  4,
                                  label: 'Account',
                                  selected: currentIndex,
                                  icon: MyIcons.accountOutline,
                                  activeIcon: MyIcons.account,
                                  onTap: navigationChange,
                                  barIsTransparent: barIsTransparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            });
          }),
    );
  }
}

class BasicRootProvider extends ChangeNotifier {
  double bottomPadding = kToolbarHeight;

  Map<int, dynamic> pageScrollControllers = {};
  Map<int, GlobalKey<NavigatorState>> pageNavigators = {};

  Map<int, String> navigatorsTop = {
    0: '/',
    1: '/',
    2: '/',
    3: '/',
    4: '/',
  };

  BasicRootProvider();

  notify() {
    notifyListeners();
  }
}

class NavigationBarItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final double iconSize;
  final int selected;
  final bool barIsTransparent;

  final Function(int index) onTap;

  const NavigationBarItem(this.index,
      {Key? key,
      required this.label,
      required this.selected,
      required this.icon,
      required this.onTap,
      required this.barIsTransparent,
      this.activeIcon,
      this.iconSize = 27})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CupertinoTabBar(items: items)

    bool isSelected = index == selected;

    Color activeColor = barIsTransparent
        ? Colors.white
        : Theme.of(context).bottomNavigationBarTheme.selectedItemColor!;

    Color inactiveColor =
        Theme.of(context).bottomNavigationBarTheme.unselectedItemColor!;

    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon ?? icon : icon,
              size: iconSize,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: CupertinoTheme.of(context)
                  .textTheme
                  .tabLabelTextStyle
                  .copyWith(color: isSelected ? activeColor : null),
            )
          ],
        ),
      ),
    );
  }
}

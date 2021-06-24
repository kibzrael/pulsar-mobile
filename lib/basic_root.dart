import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/pages/home_page.dart';
import 'package:pulsar/pages/message_screen.dart';
import 'package:pulsar/pages/my_galaxy.dart';
import 'package:pulsar/pages/my_profile.dart';
import 'package:pulsar/post/post_screen.dart';
import 'package:pulsar/widgets/route.dart';

class BasicRoot extends StatefulWidget {
  @override
  _BasicRootState createState() => _BasicRootState();
}

class _BasicRootState extends State<BasicRoot> {
  late bool themeIsDark;

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
          .push(myPageRoute(builder: (context) => PostProcess()));
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
              CarouselController controller = pageController;
              controller.animateToPage(0,
                  duration: Duration(seconds: 1), curve: Curves.ease);
            } else if (pageController!.hasClients)
              pageController!.animateTo(0.0,
                  duration: Duration(seconds: 1), curve: Curves.ease);
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
    themeIsDark =
        currentIndex == 0 || Theme.of(context).brightness == Brightness.dark;
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
      child: Provider<BasicRootProvider>(
          create: (_) => BasicRootProvider(),
          builder: (context, child) {
            return Consumer<BasicRootProvider>(
                builder: (context, provider, child) {
              basicRootProvider = provider;
              return Scaffold(
                extendBody: true,
                resizeToAvoidBottomInset: false,
                body: PageView(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    HomePage(),
                    MyGalaxy(),
                    Container(),
                    MessageScreen(),
                    MyProfilePage(),
                  ],
                ),
                bottomNavigationBar: CupertinoTabBar(
                  border: Border(
                    top: BorderSide(color: Colors.transparent),
                  ),
                  backgroundColor: Colors.transparent,
                  activeColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                  inactiveColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor!,
                  onTap: navigationChange,
                  currentIndex: currentIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(MyIcons.home)),
                    BottomNavigationBarItem(icon: Icon(MyIcons.explore)),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Transform.rotate(
                          angle: 45,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).accentColor,
                                  themeIsDark
                                      ? Colors.transparent
                                      : Colors.white,
                                  Theme.of(context).buttonColor,
                                ],
                              ),
                            ),
                            child: Transform.rotate(
                              angle: -45,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themeIsDark
                                      ? Colors.black45
                                      : Colors.white54,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  MyIcons.add,
                                  size: 30,
                                  color:
                                      themeIsDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BottomNavigationBarItem(icon: Icon(MyIcons.message)),
                    BottomNavigationBarItem(icon: Icon(MyIcons.account)),
                  ],
                ),
              );
            });
          }),
    );
  }
}

class BasicRootProvider {
  double bottomPadding = kToolbarHeight;

  Map<int, dynamic> pageScrollControllers = {};
  Map<int, GlobalKey<NavigatorState>> pageNavigators = {};
}

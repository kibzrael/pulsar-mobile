import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/settings/admin/category.dart';
import 'package:pulsar/settings/admin/challenge.dart';
import 'package:pulsar/settings/admin/reports.dart';

class PulsarAdmin extends StatefulWidget {
  const PulsarAdmin({Key? key}) : super(key: key);

  @override
  State<PulsarAdmin> createState() => _PulsarAdminState();
}

class _PulsarAdminState extends State<PulsarAdmin> {
  late PageController pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [CreateCategory(), CreateChallenge(), ViewReports()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            elevation: 16,
            onTap: (page) {
              pageController.jumpToPage(page);
              setState(() => index = page);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(MyIcons.account, size: 21), label: "Category"),
              BottomNavigationBarItem(
                  icon: Icon(MyIcons.explore), label: "Challenge"),
              BottomNavigationBarItem(
                  icon: Icon(MyIcons.report), label: "Reports")
            ]));
  }
}

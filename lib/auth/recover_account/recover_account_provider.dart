import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';

class RecoverAccountProvider extends ChangeNotifier {
  PageController? get pageController => _pageController;

  late PageController _pageController;

  int? _page;

  User? user;

  RecoverAccountProvider() {
    _pageController = PageController();
    user = melissa;
  }

  previousPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! - 1);
  }

  nextPage() {
    _page = _pageController.page!.floor();
    _pageController.jumpToPage(_page! + 1);
  }
}

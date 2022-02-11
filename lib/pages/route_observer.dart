import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  BuildContext context;
  int index;

  MyRouteObserver(this.context, this.index);

  void _sendScreenView(PageRoute<dynamic> route) {
    String? screenName = route.settings.name;
    BasicRootProvider provider =
        Provider.of<BasicRootProvider>(context, listen: false);
    provider.navigatorsTop.update(index, (value) => '$screenName');
    provider.notify();
    debugPrint('${provider.navigatorsTop}');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && route.settings.name != '/') {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route myPageRoute(
    {required Widget Function(BuildContext) builder,
    bool fullscreenDialog = false,
    bool maintainState = true,
    RouteSettings? settings,
    String? title}) {
  if (Platform.isAndroid) {
    // return CupertinoPageRoute(
    //     builder: builder!,
    //     fullscreenDialog: fullscreenDialog ?? false,
    //     maintainState: maintainState ?? true,
    //     settings: settings,
    //     title: title);
    return MaterialPageRoute(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      settings: settings,
    );
  } else {
    return CupertinoPageRoute(
      builder: builder,
      fullscreenDialog: fullscreenDialog,
      maintainState: maintainState,
      settings: settings,
      title: title,
    );
  }
}

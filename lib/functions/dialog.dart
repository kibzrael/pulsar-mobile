import 'package:flutter/cupertino.dart';

openDialog(context, Widget Function(BuildContext) builder,
    {dismissible = false}) {
  showCupertinoDialog(
      context: context,
      builder: builder,
      useRootNavigator: true,
      barrierDismissible: dismissible);
}

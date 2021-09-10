import 'package:flutter/cupertino.dart';

Future<T?> openDialog<T>(context, Widget Function(BuildContext) builder,
    {bool dismissible = false}) async {
  var value = await showCupertinoDialog(
    context: context,
    builder: builder,
    useRootNavigator: true,
    barrierDismissible: dismissible,
  );

  return value;
}

import 'package:flutter/material.dart';

Future<dynamic> openBottomSheet(
    BuildContext context, Widget Function(BuildContext) builder,
    {bool root = true, bool enableDrag = true}) async {
  dynamic value = await showModalBottomSheet(
      context: context,
      //isDismissible: true,
      isScrollControlled: true,
      enableDrag: enableDrag,
      useRootNavigator: root,
      backgroundColor: Colors.transparent,
      builder: builder);
  return value;
}

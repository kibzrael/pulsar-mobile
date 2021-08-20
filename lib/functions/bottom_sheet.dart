import 'package:flutter/material.dart';

openBottomSheet(BuildContext context, Widget Function(BuildContext) builder,
    {bool root = true}) {
  showModalBottomSheet(
      context: context,
      //isDismissible: true,
      isScrollControlled: true,
      useRootNavigator: root,
      backgroundColor: Colors.transparent,
      builder: builder);
}

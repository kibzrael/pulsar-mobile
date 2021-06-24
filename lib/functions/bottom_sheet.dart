import 'package:flutter/material.dart';

openBottomSheet(BuildContext context, Widget Function(BuildContext) builder) {
  showModalBottomSheet(
      context: context,
      //isDismissible: true,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: builder);
}

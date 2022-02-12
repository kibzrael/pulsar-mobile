import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class AuthMenu extends StatelessWidget {
  const AuthMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // language, theme, terms of use, policies
    return const MyBottomSheet(
      child: SizedBox(
        height: 300,
      ),
    );
  }
}

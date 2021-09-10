import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class InfoSheet extends StatelessWidget {
  const InfoSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: SizedBox(
        height: 300,
      ),
    );
  }
}

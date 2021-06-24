import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class CaptureSpeed extends StatefulWidget {
  @override
  _CaptureSpeedState createState() => _CaptureSpeedState();
}

class _CaptureSpeedState extends State<CaptureSpeed> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: SizedBox(
        height: 200,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class SharePost extends StatefulWidget {
  @override
  _SharePostState createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: SizedBox(
        height: 200,
      ),
    );
  }
}

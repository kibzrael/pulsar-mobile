import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/section.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      fullDialog: true,
      title: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SectionTitle(title: 'Gallery')),
      child: SizedBox(
        height: 200,
      ),
    );
  }
}

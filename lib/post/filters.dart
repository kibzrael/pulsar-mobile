import 'package:flutter/material.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: SizedBox(
        height: 200,
      ),
    );
  }
}

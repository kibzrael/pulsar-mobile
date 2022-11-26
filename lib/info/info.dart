import 'package:flutter/material.dart';
import 'package:pulsar/classes/info.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/section.dart';

class InfoSheet extends StatelessWidget {
  final Info info;
  const InfoSheet(this.info, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      maxRatio: 0.8,
      child: Scaffold(
        body: ListView.builder(
            itemCount: info.sections.length,
            itemBuilder: (context, index) {
              InfoSection section = info.sections[index];
              return Section(
                  title: section.title,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(section.description),
                  ));
            }),
      ),
    );
  }
}

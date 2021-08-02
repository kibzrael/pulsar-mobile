import 'package:flutter/material.dart';
import 'package:pulsar/classes/option.dart';
import 'package:pulsar/widgets/bottom_sheet.dart';
import 'package:pulsar/widgets/list_tile.dart';

class Options extends StatelessWidget {
  final List<Option> options;

  Options(this.options);

  @override
  Widget build(BuildContext context) {
    return MyBottomSheet(
      child: ListView.builder(
          itemCount: options.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Option option = options[index];
            return MyListTile(
              title: option.name,
              leading: Icon(option.icon),
              onPressed: option.onPressed,
            );
          }),
    );
  }
}

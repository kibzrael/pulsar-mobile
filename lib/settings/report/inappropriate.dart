import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class ReportInappropriate extends StatefulWidget {
  const ReportInappropriate({Key? key}) : super(key: key);

  @override
  _ReportInappropriateState createState() => _ReportInappropriateState();
}

class _ReportInappropriateState extends State<ReportInappropriate> {
  String issue = 'None';
  String user = 'None';
  String post = 'None';
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: Container(
        height: constraints.maxHeight,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: [
            Text(
              'Report a user or post that violated the rules of the app.',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            MyListTile(title: 'Issue', trailingText: issue),
            MyListTile(title: 'User', trailingText: user),
            MyListTile(title: 'Post', trailingText: post),
            const SizedBox(height: 15),
            const TextField(
              maxLength: 255,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 15),
            MyListTile(leading: Icon(MyIcons.attatchment), title: 'Attachment')
          ],
        ),
      ));
    });
  }
}

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

  String description = '';
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
          child: Container(
        height: constraints.maxHeight,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                'Report a user or post that violated the rules of the app.',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            MyListTile(
              title: 'Issue',
              trailingText: issue,
              flexRatio: const [0, 1],
            ),
            MyListTile(
              title: 'User',
              trailingText: user,
              flexRatio: const [0, 1],
            ),
            MyListTile(
              title: 'Post',
              trailingText: post,
              flexRatio: const [0, 1],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                maxLength: 255,
                minLines: 1,
                maxLines: 4,
                onChanged: (text) => setState(() => description = text),
                decoration: InputDecoration(
                    hintText: 'Description',
                    counter: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${description.length}/255',
                        style:
                            Theme.of(context).inputDecorationTheme.counterStyle,
                      ),
                    ),
                    helperMaxLines: 3,
                    helperText:
                        'Briefly explain the issue you are facing. Expound on how it affects you and measures to be taken to resolve it.'),
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

import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/list_tile.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({Key? key}) : super(key: key);

  @override
  State<ReportIssue> createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  String issue = 'App crash';
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
                'Report an error in the app, or a crash.',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            MyListTile(
              title: 'Issue',
              trailingText: issue,
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
                        'Briefly explain the situation you are facing. If any, suggest a way to fix it to meet your needs.'),
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

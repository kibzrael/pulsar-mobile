import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/functions/bottom_sheet.dart';
import 'package:pulsar/info/info.dart';
import 'package:pulsar/settings/report/inappropriate.dart';
import 'package:pulsar/settings/report/issue.dart';
import 'package:pulsar/widgets/custom_tab.dart';

class ReportScreen extends StatefulWidget {
  final int initialIndex;
  ReportScreen({this.initialIndex = 0});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Report'),
          actions: [
            IconButton(
                onPressed: () {
                  openBottomSheet(context, (context) => InfoSheet());
                },
                icon: Icon(MyIcons.info))
          ],
          bottom: TabBar(
            indicator: BoxDecoration(),
            labelPadding: EdgeInsets.zero,
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            tabs: [
              CustomTab('Issue'),
              CustomTab(
                'Inappropriate',
                divider: false,
              )
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBarView(
            children: [ReportIssue(), ReportInappropriate()],
          ),
        ),
      ),
    );
  }
}

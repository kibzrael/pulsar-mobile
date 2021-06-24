import 'package:flutter/material.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/widgets/custom_tab.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Report'),
          actions: [IconButton(onPressed: () {}, icon: Icon(MyIcons.info))],
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
            children: [Container(), Container()],
          ),
        ),
      ),
    );
  }
}

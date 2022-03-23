import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/widgets/custom_tab.dart';
import 'package:pulsar/widgets/list_tile.dart';
import 'package:pulsar/widgets/profile_pic.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({Key? key}) : super(key: key);

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        bottom: TabBar(
            indicator: const BoxDecoration(),
            unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
            labelPadding: EdgeInsets.zero,
            controller: controller,
            tabs: const [
              CustomTab("Issues"),
              CustomTab("Inappropriate", divider: false)
            ]),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: TabBarView(controller: controller, children: [
          for (int i = 0; i < 2; i++)
            ListView.builder(
                itemCount: 4,
                itemBuilder: ((context, index) => MyListTile(
                      leading: ProfilePic(allUsers[index].profilePic?.thumbnail,
                          radius: 30),
                      title: "Issue Title",
                      subtitle: "@${allUsers[index].username}",
                      onPressed: () {},
                    )))
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/models/discover_tags.dart';
import 'package:pulsar/notifications/notification_card.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/activity_provider.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  GlobalKey<NavigatorState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Provider.of<BasicRootProvider>(context, listen: false)
        .pageNavigators
        .putIfAbsent(3, () => key);
    return Navigator(
      key: key,
      initialRoute: '/',
      observers: [MyRouteObserver(context, 3)],
      onGenerateRoute: (settings) {
        return myPageRoute(
            settings: settings,
            builder: (context) => const RootNotificationsPage());
      },
    );
  }
}

class RootNotificationsPage extends StatefulWidget {
  const RootNotificationsPage({Key? key}) : super(key: key);

  @override
  State<RootNotificationsPage> createState() => _RootNotificationsPageState();
}

class _RootNotificationsPageState extends State<RootNotificationsPage> {
  late ActivityProvider provider;

  List<InteractionActivity> fetchedActivity = [];
  String tag = 'All';

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [IconButton(icon: Icon(MyIcons.tune), onPressed: () {})],
      ),
      body: VisibilityDetector(
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.5) {
            provider.markAsRead(fetchedActivity);
            debugPrint("Activity Tab Opened");
          }
        },
        key: const Key("Activity"),
        child: RecyclerView(
            target: provider.fetchUpdates,
            dataLength: 20,
            itemBuilder: (context, snapshot) {
              List<InteractionActivity> data = [
                ...provider.realtimeUpdates,
                ...snapshot.data.map((e) => InteractionActivity.fromJson(e))
              ];
              fetchedActivity = [...data];
              // Remove any duplicates
              Set ids = {};
              data.retainWhere((e) => ids.add(e.id));
              List<InteractionActivity> filteredData = data
                  .where((e) =>
                      interactionLabels[e.type.name] == tag || tag == 'All')
                  .toList();
              return data.isEmpty
                  ? snapshot.errorLoading
                      ? snapshot.noData
                          ? const NoPosts(
                              alignment: Alignment.center,
                              message: 'You have no Activity')
                          : NetworkError(onRetry: snapshot.refreshCallback)
                      : const Center(child: MyProgressIndicator())
                  : Column(
                      children: [
                        Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: ListView.builder(
                              itemCount: Interaction.values.length + 1,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String name = index == 0
                                    ? 'All'
                                    : interactionLabels[Interaction
                                            .values[index - 1].name] ??
                                        '';
                                return TagWidget(
                                    text: name,
                                    isSelected: tag == name,
                                    onPressed: (selected) {
                                      setState(() {
                                        tag = selected;
                                      });
                                    });
                              }),
                        ),
                        if (filteredData.isNotEmpty)
                          Flexible(
                            child: RefreshIndicator(
                              onRefresh: snapshot.refreshCallback,
                              child: ListView.separated(
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return InteractionNotificationCard(
                                    filteredData[index],
                                    key: ValueKey(DateTime.now()),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 4,
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          Flexible(
                            child: NoPosts(
                                alignment: Alignment.center,
                                message: 'You have no $tag'),
                          )
                      ],
                    );
            }),
      ),
    );
  }
}

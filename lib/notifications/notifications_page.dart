import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/basic_root.dart';
import 'package:pulsar/classes/activity.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/notifications/notification_card.dart';
import 'package:pulsar/pages/route_observer.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/activity_provider.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
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
  _RootNotificationsPageState createState() => _RootNotificationsPageState();
}

class _RootNotificationsPageState extends State<RootNotificationsPage> {
  late ActivityProvider provider;

  Future onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [IconButton(icon: Icon(MyIcons.tune), onPressed: () {})],
      ),
      body: RecyclerView(
          target: provider.fetchUpdates,
          dataLength: 20,
          itemBuilder: (context, snapshot) {
            List<InteractionActivity> data = [
              ...snapshot.data.map((e) => InteractionActivity.fromJson(e))
            ];
            return data.isEmpty
                ? snapshot.errorLoading
                    ? snapshot.noData
                        ? const NoPosts(
                            alignment: Alignment.center,
                            message: 'You have no Activity')
                        : NetworkError(onRetry: snapshot.refreshCallback)
                    : const Center(child: MyProgressIndicator())
                : RefreshIndicator(
                    onRefresh: onRefresh,
                    child: ListView.separated(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InteractionNotificationCard(data[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 12,
                        );
                      },
                    ),
                  );
          }),
    );
  }
}

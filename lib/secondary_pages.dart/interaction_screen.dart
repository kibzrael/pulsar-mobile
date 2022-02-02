import 'package:flutter/material.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/section.dart';

class InteractionScreen extends StatefulWidget {
  final User? user;
  final Challenge? challenge;

  InteractionScreen({
    this.user,
    this.challenge,
  });

  @override
  _InteractionScreenState createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  User? user;
  Challenge? challenge;

  late bool isUser;

  Future<List<Map<String, dynamic>>?> fetchData(int index) async {
    await Future.delayed(Duration(seconds: 2));
    List<Map<String, dynamic>> interactions = [
      {'user': melissa},
      {'user': rael},
      {'user': nick},
      {'user': joe},
      {'user': tom},
      {'user': beth},
      {'user': thomas},
      {'user': joy},
      {'user': lizzy},
      {'user': evah},
      {'user': chris}
    ];

    return interactions;
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    challenge = widget.challenge;
    isUser = user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@${isUser ? user!.username : challenge!.name}'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Section(
          title: isUser ? 'Followers' : 'Pins',
          trailing: Text(
            '22K',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          child: Flexible(
              child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: RecyclerView(
                target: fetchData,
                itemBuilder: (context, snapshot) {
                  List<Map<String, dynamic>>? data = snapshot.data;
                  if (snapshot.errorLoading) print(snapshot.error);
                  return data.isEmpty
                      ? snapshot.errorLoading
                          ? Text('${snapshot.error} $data')
                          : Center(child: MyProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: snapshot.refreshCallback,
                          child: ListView.builder(
                              itemCount: data.length + 1,
                              itemBuilder: (context, index) {
                                if (data.isNotEmpty) {
                                  if (index == 5) {
                                    return ListTileAd();
                                  }
                                  if (index > 5) {
                                    return UserCard(data[index - 1]['user']);
                                  }
                                  return UserCard(data[index]['user']);
                                }
                                return Container();
                              }),
                        );
                }),
          )),
        ),
      ),
    );
  }
}

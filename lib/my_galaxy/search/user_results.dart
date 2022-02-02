import 'package:flutter/material.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/widgets/loading_more.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class UserResults extends StatefulWidget {
  @override
  _UserResultsState createState() => _UserResultsState();
}

class _UserResultsState extends State<UserResults>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<Map<String, dynamic>>?> search(int index) async {
    await Future.delayed(Duration(seconds: 2));
    List<Map<String, dynamic>> results = [
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

    return results;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RecyclerView(
        target: search,
        itemBuilder: (context, snapshot) {
          List<Map<String, dynamic>>? data = snapshot.data;
          return data.isEmpty
              ? snapshot.errorLoading
                  ? Text('${snapshot.error} $data')
                  : Center(child: MyProgressIndicator())
              : RefreshIndicator(
                  onRefresh: snapshot.refreshCallback,
                  child: ListView.builder(
                    itemCount: data.length + (snapshot.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (snapshot.isLoadingMore && index == data.length) {
                        return LoadingMore();
                      }
                      // if (index == 5) {
                      //   return MyBannerAd();
                      // }
                      // if (index > 5) {
                      //   return UserCard(data[index - 1]['user']);
                      // }
                      return UserCard(data[index]['user']);
                    },
                  ),
                );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/widgets/loading_more.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class UserResults extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(int page, int index) target;
  const UserResults({required this.target, Key? key}) : super(key: key);

  @override
  _UserResultsState createState() => _UserResultsState();
}

class _UserResultsState extends State<UserResults> {
  Future<List<Map<String, dynamic>>?> search(int index) async {
    List<Map<String, dynamic>> results = await widget.target(0, index);

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return RecyclerView(
        target: search,
        itemBuilder: (context, snapshot) {
          List<Map<String, dynamic>>? data = snapshot.data;
          return data.isEmpty
              ? snapshot.errorLoading
                  ? snapshot.noData
                      ? const NoPosts(
                          alignment: Alignment.center,
                          message: 'No results found')
                      : NetworkError(onRetry: snapshot.refreshCallback)
                  : const Center(child: MyProgressIndicator())
              : RefreshIndicator(
                  onRefresh: snapshot.refreshCallback,
                  child: ListView.builder(
                    itemCount: data.length + (snapshot.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (snapshot.isLoadingMore && index == data.length) {
                        return const LoadingMore();
                      }
                      // if (index == 5) {
                      //   return MyBannerAd();
                      // }
                      // if (index > 5) {
                      //   return UserCard(data[index - 1]['user']);
                      // }
                      return UserCard(User.fromJson(data[index]));
                    },
                  ),
                );
        });
  }
}

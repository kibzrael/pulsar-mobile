import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/models/challenge_card.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class ChallengeResults extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(int page, int index) target;
  const ChallengeResults({required this.target, Key? key}) : super(key: key);

  @override
  _ChallengeResultsState createState() => _ChallengeResultsState();
}

class _ChallengeResultsState extends State<ChallengeResults> {
  Future<List<Map<String, dynamic>>?> search(int index) async {
    List<Map<String, dynamic>> results = await widget.target(1, index);
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ChallengeCard(Challenge.fromJson(data[index]));
                    },
                  ),
                );
        });
  }
}

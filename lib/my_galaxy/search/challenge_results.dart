import 'package:flutter/material.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
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
          int ads = (data.length / 12).round();
          int dataLength = data.length + ads;
          int visibleAds = 0;
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
                    itemCount: dataLength,
                    itemBuilder: (context, index) {
                      if (index == 0) visibleAds = 0;
                      if ((index + 1) % 12 == 6 && visibleAds < ads) {
                        visibleAds++;
                        return const ListTileAd();
                      }
                      return ChallengeCard(
                          Challenge.fromJson(data[index - visibleAds]));
                    },
                  ),
                );
        });
  }
}

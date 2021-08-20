import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/models/challenge_card.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';

class ChallengeResults extends StatefulWidget {
  @override
  _ChallengeResultsState createState() => _ChallengeResultsState();
}

class _ChallengeResultsState extends State<ChallengeResults> {
  Future<List<Map<String, dynamic>>?> search(int index) async {
    await Future.delayed(Duration(seconds: 2));
    List<Map<String, dynamic>> results = [
      for (Challenge challenge in allChallenges) {'challenge': challenge}
    ];

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
                  ? Text('${snapshot.error} $data')
                  : Center(child: MyProgressIndicator())
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ChallengeCard(data[index]['challenge']);
                  },
                );
        });
  }
}

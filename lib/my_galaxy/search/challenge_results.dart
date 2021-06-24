import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/models/challenge_card.dart';

class ChallengeResults extends StatefulWidget {
  @override
  _ChallengeResultsState createState() => _ChallengeResultsState();
}

class _ChallengeResultsState extends State<ChallengeResults> {
  List<Challenge> results = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  search() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      results = allChallenges;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ChallengeCard(results[index]);
      },
    );
  }
}

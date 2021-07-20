import 'package:flutter/material.dart';
import 'package:pulsar/ads/banner_ad.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/data/users.dart';
import 'package:pulsar/models/user_card.dart';

class UserResults extends StatefulWidget {
  @override
  _UserResultsState createState() => _UserResultsState();
}

class _UserResultsState extends State<UserResults> {
  List<User> results = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  search() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted)
      setState(() {
        results = allUsers;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length + 1,
      itemBuilder: (context, index) {
        if (results.isNotEmpty) {
          if (index == 5) {
            return MyBannerAd();
          }
          if (index > 5) {
            return UserCard(results[index - 1]);
          }
          return UserCard(results[index]);
        }
        return Container();
      },
    );
  }
}

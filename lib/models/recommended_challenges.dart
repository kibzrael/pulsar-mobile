import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/secondary_button.dart';
import 'package:pulsar/widgets/section.dart';

class RecommendedChallenges extends StatefulWidget {
  @override
  _RecommendedChallengesState createState() => _RecommendedChallengesState();
}

class _RecommendedChallengesState extends State<RecommendedChallenges> {
  List<Challenge> challenges = [
    adventure,
    landscape,
    bestOfTokyo,
    pet,
    streetDance,
    litByFire,
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Recommended',
      trailing: SecondaryButton(text: 'View all'),
      child: Container(
        height: 180,
        margin: EdgeInsets.only(top: 5),
        child: ListView.builder(
          itemCount: challenges.length,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 7.5),
          itemBuilder: (context, index) {
            Challenge challenge = challenges[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(myPageRoute(
                    builder: (context) => ChallengePage(challenge)));
              },
              child: Card(
                margin: EdgeInsets.fromLTRB(
                    7.5, 0, 7.5, 10), //symmetric(horizontal: 7.5, vertical: 5),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12), bottom: Radius.circular(15))),
                child: Container(
                  width: 150,
                  padding: EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            image: DecorationImage(
                                image: AssetImage(challenge.coverPhoto!),
                                fit: BoxFit.cover)),
                      )),
                      Text(
                        challenge.name,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 16.5),
                        maxLines: 1,
                      ),
                      Text(
                        'Category',
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

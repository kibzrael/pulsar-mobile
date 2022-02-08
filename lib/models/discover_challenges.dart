import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/data/categories.dart';
import 'package:pulsar/data/challenges.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/widgets/route.dart';

class DiscoverChallenges extends StatefulWidget {
  @override
  _DiscoverChallengesState createState() => _DiscoverChallengesState();
}

class _DiscoverChallengesState extends State<DiscoverChallenges>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Challenge> challenges = [
    adventure,
    breakup,
    landscape,
    bestOfTokyo,
    pet,
    bestOfNewYork,
    streetDance,
    litByFire,
  ];

  List<String> tags = [
    'For you',
    'Trending',
    ...allCategories.map((e) => e.name)
  ];

  String selected = 'For you';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            height: 56,
            child: ListView.builder(
                itemCount: tags.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemBuilder: (context, index) {
                  return ChallengeTag(
                    tags[index],
                    isSelected: selected == tags[index],
                    onPressed: () => setState(() => selected = tags[index]),
                  );
                }),
          ),
          Container(
            height: 225,
            margin: EdgeInsets.only(top: 12),
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
                    margin: EdgeInsets.fromLTRB(7.5, 0, 7.5,
                        10), //symmetric(horizontal: 7.5, vertical: 5),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                            bottom: Radius.circular(15))),
                    child: Container(
                      width: 180,
                      padding: EdgeInsets.only(bottom: 5),
                      child: Column(
                        children: [
                          Container(
                            height: 125,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        challenge.coverPhoto!),
                                    fit: BoxFit.cover)),
                          ),
                          Spacer(),
                          Text(
                            challenge.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 18),
                            maxLines: 1,
                          ),
                          Text(
                            'Category',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontSize: 16.5),
                            maxLines: 1,
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    MyIcons.play,
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '3.14K',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    MyIcons.pin,
                                    size: 16.5,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '4.5K',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeTag extends StatefulWidget {
  final String tag;
  final bool isSelected;
  final Function() onPressed;
  ChallengeTag(this.tag, {required this.isSelected, required this.onPressed});

  @override
  _ChallengeTagState createState() => _ChallengeTagState();
}

class _ChallengeTagState extends State<ChallengeTag> {
  bool get isSelected => widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: AnimatedContainer(
          padding: EdgeInsets.only(left: 8, right: 12),
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
              gradient: isSelected ? secondaryGradient() : null,
              borderRadius: BorderRadius.circular(30)),
          child: Row(children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Theme.of(context).dividerColor,
            ),
            SizedBox(width: 8),
            Text(
              widget.tag,
              style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.subtitle2!.color),
            )
          ]),
        ),
      ),
    );
  }
}

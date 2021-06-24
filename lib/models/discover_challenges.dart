import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/widgets/follow_button.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/data/challenges.dart';

class DiscoverChallenges extends StatefulWidget {
  @override
  _DiscoverChallengesState createState() => _DiscoverChallengesState();
}

class _DiscoverChallengesState extends State<DiscoverChallenges>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Challenge> challenges = [
    cuisines,
    breakup,
    adventure,
    bestOfNewYork,
    landscape,
    telephoneGame,
    paintChallenge,
    modellingChallenge,
    gymnasticChallenge,
    danceChallenge,
    puppetryChallenge,
  ];
  CarouselController? carouselController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double cardWidth = (MediaQuery.of(context).size.width * 0.8) - 15;
    double cardHeight = cardWidth * (4.2 / 3);
    return Section(
      title: 'Discover Challenges',
      child: CarouselSlider(
        //use a controller on pin
        carouselController: carouselController,
        options: CarouselOptions(
          height: cardHeight + 10,
          viewportFraction: 0.8,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          initialPage: 0,
          onPageChanged: (index, reason) {
            setState(() {});
          },
        ),
        items: challenges.map((challenge) {
          return DiscoverChallengesCard(
            challenge,
            cardWidth: cardWidth,
            onPinned: () {
              carouselController!.nextPage(
                  duration: Duration(milliseconds: 700), curve: Curves.ease);
            },
          );
        }).toList(),
      ),
    );
  }
}

class DiscoverChallengesCard extends StatefulWidget {
  final Challenge challenge;
  final double? cardWidth;
  final Function? onPinned;
  DiscoverChallengesCard(this.challenge, {this.cardWidth, this.onPinned});
  @override
  _DiscoverChallengesCardState createState() => _DiscoverChallengesCardState();
}

class _DiscoverChallengesCardState extends State<DiscoverChallengesCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isPinned = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double cardWidth = widget.cardWidth!;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            myPageRoute(builder: (context) => ChallengePage(widget.challenge)));
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
        ),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: '${widget.challenge.id}',
                child: Container(
                  height: cardWidth / 2,
                  width: cardWidth / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor,
                    image: DecorationImage(
                        image: AssetImage(widget.challenge.coverPhoto!),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('${widget.challenge.name}',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 21)),
                    ),
                    Center(
                      child: Text('Category',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: cardWidth,
                  decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      image: DecorationImage(
                          image: AssetImage(widget.challenge.coverPhoto!),
                          fit: BoxFit.cover)),
                  foregroundDecoration: BoxDecoration(color: Colors.black45),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                child: FollowButton(
                    isFollowing: isPinned,
                    text: {true: 'Pinned', false: 'Pin'},
                    onPressed: () {
                      setState(() {
                        isPinned = !isPinned;
                      });

                      if (isPinned) {
                        widget.onPinned!();
                      }
                    },
                    height: 37.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

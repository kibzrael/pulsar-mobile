import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenges.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';
import 'package:pulsar/data/challenges.dart';

class PinnedChallenges extends StatefulWidget {
  const PinnedChallenges({Key? key}) : super(key: key);

  @override
  _PinnedChallengesState createState() => _PinnedChallengesState();
}

class _PinnedChallengesState extends State<PinnedChallenges>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollController scrollController = ScrollController();

  late UserProvider userProvider;

  List<Challenge> testChallenges = [
    urbanPortraits,
    litByFire,
    tapDance,
    afro,
    ballerinaArt,
    amazingFlowers,
    bestOfCairo,
    interiorChallenge,
    photographyChallenge,
    karaokeChallenge,
    actingChallenge,
    magicChallenge,
  ];

  Future<List<Map<String, dynamic>>> fetchChallenges(int index) async {
    List<Map<String, dynamic>> result = [];
    // String url = getUrl(ChallengesUrl.pinned);

    // http.Response response = await http.get(Uri.parse(url),
    //     headers: {"Authorization": userProvider.user.token ?? ""});

    // var responseData = jsonDecode(response.body);

    // if (responseData is Map) {
    //   result = List<Map<String,dynamic>>.from(responseData['challenges']);
    // }
    result = [...testChallenges.map((e) => e.toJson())];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    userProvider = Provider.of<UserProvider>(context);
    return Section(
      title: "Challenges",
      child: Container(
        height: 125,
        margin: const EdgeInsets.only(top: 5),
        child: RecyclerView(
            target: fetchChallenges,
            itemBuilder: (context, snapshot) {
              List<Map<String, dynamic>> snapshotData = snapshot.data;
              List<Challenge> challenges = [
                ...snapshotData.map((e) => Challenge.fromJson(e))
              ];
              return snapshotData.isEmpty
                  ? snapshot.errorLoading
                      ? snapshot.noData
                          ? const Center(
                              child: Text("No pinned Challenges yet"))
                          : const Center(child: Text("Network Error"))
                      : const Center(child: MyProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: challenges.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          width: 15,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Challenge challenge = challenges[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(myPageRoute(
                                  builder: (context) =>
                                      ChallengePage(challenge)));
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  21,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Hero(
                                    tag: '${challenge.id}',
                                    child: Container(
                                      height: 125,
                                      width: 175,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .fillColor,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                challenge.cover.photo(context,
                                                    max: 'medium')),
                                            fit: BoxFit.cover),
                                      ),
                                      foregroundDecoration: const BoxDecoration(
                                          color: Colors.black12),
                                    ),
                                  ),
                                  Container(
                                    height: 125,
                                    width: 175,
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          challenge.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                fontSize: 21,
                                                color: Colors.white,
                                              ),
                                          maxLines: 2,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height: 125,
                                      width: 175,
                                      padding: const EdgeInsets.all(8),
                                      alignment: Alignment.topLeft,
                                      child: Transform.rotate(
                                        angle: 45,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(MyIcons.pin,
                                              color: Colors.white),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            }),
      ),
    );
  }
}

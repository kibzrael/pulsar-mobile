import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/discover_challenges_ad.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/theme_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenges.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';

class DiscoverChallenges extends StatefulWidget {
  final List<Map<String, dynamic>> initial;
  const DiscoverChallenges(this.initial, {Key? key}) : super(key: key);

  @override
  _DiscoverChallengesState createState() => _DiscoverChallengesState();
}

class _DiscoverChallengesState extends State<DiscoverChallenges> {
  late UserProvider userProvider;

  List<CategoryTag> tags = [
    CategoryTag(
        'For you',
        Photo(
          thumbnail: 'assets/categories/for you-48.png',
          medium: 'assets/categories/for you-96.png',
          high: 'assets/categories/for you-256.png',
        )),
    CategoryTag(
        'Trending',
        Photo(
          thumbnail: 'assets/categories/trending-48.png',
          medium: 'assets/categories/trending-96.png',
          high: 'assets/categories/trending-256.png',
        )),
  ];

  String tag = 'For you';

  String dataTag = '';

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    setTags();
  }

  setTags() async {
    List<Interest> activeTags = await userProvider.activeCategories(context);
    tags = [
      ...tags,
      ...activeTags
          .where((e) => e.parent == null)
          .map((e) => CategoryTag(e.name, e.cover!))
    ];
  }

  Future<List<Map<String, dynamic>>> fetchChallenges(int index) async {
    String storedTag = tag;
    List<Map<String, dynamic>> result = [];
    if (index == 0 && tag == 'For you') {
      result = [...widget.initial];
    } else {
      String url = getUrl(ChallengesUrl.discover(tag, index));

      http.Response response = await http.get(Uri.parse(url),
          headers: {"Authorization": userProvider.user.token ?? ""});

      var responseData = jsonDecode(response.body);

      if (responseData is Map) {
        result = List<Map<String, dynamic>>.from(responseData['challenges']);
      }
    }
    dataTag = storedTag;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: RecyclerView(
          target: fetchChallenges,
          dataLength: 12,
          itemBuilder: (context, snapshot) {
            List<Map<String, dynamic>> snapshotData = snapshot.data;
            List<Challenge> challenges = [
              ...snapshotData.map((e) => Challenge.fromJson(e))
            ];
            int ads = (challenges.length / 12).round();
            int dataLength = challenges.length + ads;
            int visibleAds = 0;
            return Column(
              children: [
                SizedBox(
                  height: 56,
                  child: ListView.builder(
                      itemCount: tags.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, index) {
                        return ChallengeTag(
                          tags[index],
                          isSelected: tag == tags[index].name,
                          onPressed: () => setState(() {
                            tag = tags[index].name;
                            snapshot.refreshCallback();
                          }),
                        );
                      }),
                ),
                Container(
                  height: 220,
                  margin: const EdgeInsets.only(top: 12),
                  child: challenges.isEmpty
                      ? snapshot.errorLoading
                          ? snapshot.error == ApiError.connection
                              ? NetworkErrorModel(
                                  onRetry: snapshot.refreshCallback)
                              : const NoPostsModel()
                          : const Center(child: MyProgressIndicator())
                      : dataTag != tag
                          ? const Center(child: MyProgressIndicator())
                          : ListView.builder(
                              itemCount: dataLength,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.5),
                              itemBuilder: (context, index) {
                                if (index == 0) visibleAds = 0;
                                if ((index + 1) % 12 == 6 && visibleAds < ads) {
                                  visibleAds++;
                                  return const DiscoverChallengesAd();
                                }
                                Challenge challenge =
                                    challenges[index - visibleAds];

                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(myPageRoute(
                                        builder: (context) =>
                                            ChallengePage(challenge)));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.fromLTRB(
                                        7.5,
                                        0,
                                        7.5,
                                        10), //symmetric(horizontal: 7.5, vertical: 5),
                                    elevation: 4,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12),
                                            bottom: Radius.circular(15))),
                                    child: Container(
                                      width: 180,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 125,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                borderRadius: const BorderRadius
                                                        .vertical(
                                                    top: Radius.circular(12)),
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            challenge.cover.photo(
                                                                context,
                                                                max: 'medium')),
                                                    fit: BoxFit.cover)),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              challenge.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 18),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              challenge.description ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(fontSize: 15),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          }),
    );
  }
}

class CategoryTag {
  String name;
  Photo cover;

  CategoryTag(this.name, this.cover);
}

class ChallengeTag extends StatefulWidget {
  final CategoryTag tag;
  final bool isSelected;
  final Function() onPressed;
  const ChallengeTag(this.tag,
      {Key? key, required this.isSelected, required this.onPressed})
      : super(key: key);

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
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: AnimatedContainer(
          padding: const EdgeInsets.only(left: 8, right: 12),
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              gradient: isSelected
                  ? accentGradient(
                      begin: Alignment.centerLeft, end: Alignment.centerRight)
                  : null,
              borderRadius: BorderRadius.circular(30)),
          child: Row(children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          widget.tag.cover.photo(context, max: 'medium')))),
            ),
            const SizedBox(width: 8),
            Text(
              widget.tag.name,
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

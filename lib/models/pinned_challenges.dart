import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/icons.dart';
import 'package:pulsar/my_galaxy/challenge_page.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/localization_provider.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenges.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/route.dart';
import 'package:pulsar/widgets/section.dart';

class PinnedChallenges extends StatefulWidget {
  final List<Map<String, dynamic>> initial;
  const PinnedChallenges(this.initial, {Key? key}) : super(key: key);

  @override
  State<PinnedChallenges> createState() => _PinnedChallengesState();
}

class _PinnedChallengesState extends State<PinnedChallenges> {
  ScrollController scrollController = ScrollController();

  late UserProvider userProvider;

  Future<List<Map<String, dynamic>>> fetchChallenges(int index) async {
    List<Map<String, dynamic>> result = [];
    if (index == 0) {
      result = [...widget.initial];
    } else {
      String url = getUrl(ChallengesUrl.pinned(index));

      http.Response response = await http.get(Uri.parse(url),
          headers: {"Authorization": userProvider.user.token ?? ""});

      var responseData = jsonDecode(response.body);

      if (responseData is Map) {
        result = List<Map<String, dynamic>>.from(responseData['challenges']);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Section(
      title: local(context).challenges(0),
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
                          ? const NoPostsModel()
                          : NetworkErrorModel(onRetry: snapshot.refreshCallback)
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
                                              .bodyLarge
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
                                  if (challenge.isPinned)
                                    Container(
                                        height: 125,
                                        width: 175,
                                        padding: const EdgeInsets.all(8),
                                        alignment: Alignment.topLeft,
                                        child: Transform.rotate(
                                          angle: 45,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(MyIcons.pin,
                                                color: Colors.white, size: 30),
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

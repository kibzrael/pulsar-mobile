import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/ads/list_tile_ad.dart';
import 'package:pulsar/classes/challenge.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/functions/dynamic_count.dart';
import 'package:pulsar/models/user_card.dart';
import 'package:pulsar/placeholders/network_error.dart';
import 'package:pulsar/placeholders/no_posts.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenge.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';
import 'package:pulsar/widgets/progress_indicator.dart';
import 'package:pulsar/widgets/recycler_view.dart';
import 'package:pulsar/widgets/section.dart';

class InteractionScreen extends StatefulWidget {
  final User? user;
  final Challenge? challenge;
  final int? value;

  const InteractionScreen({
    Key? key,
    this.user,
    this.challenge,
    required this.value,
  }) : super(key: key);

  @override
  State<InteractionScreen> createState() => _InteractionScreenState();
}

class _InteractionScreenState extends State<InteractionScreen> {
  late UserProvider userProvider;

  User? user;
  Challenge? challenge;

  late bool isUser;

  Future<List<Map<String, dynamic>>?> fetchData(int index) async {
    List<Map<String, dynamic>> interactions = [];

    String url;
    if (isUser) {
      url = getUrl(UserUrls.follow(user!.id, index: index));
    } else {
      url = getUrl(ChallengeUrls.pins(challenge!, index: index));
    }

    http.Response response = await http.get(Uri.parse(url),
        headers: {'Authorization': userProvider.user.token ?? ''});

    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      interactions = [...List<Map<String, dynamic>>.from(body['data'])];
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
    return interactions;
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    challenge = widget.challenge;
    isUser = user != null;
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('@${isUser ? user!.username : challenge!.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Section(
          title: isUser ? 'Followers' : 'Pins',
          trailing: Text(
            widget.value == null ? '-' : roundCount(widget.value!),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          child: Flexible(
              child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RecyclerView(
                target: fetchData,
                itemBuilder: (context, snapshot) {
                  List<Map<String, dynamic>>? data = snapshot.data;
                  if (snapshot.errorLoading) {
                    debugPrint(snapshot.error.toString());
                  }
                  int ads = (data.length / 12).round();
                  int dataLength = data.length + ads;
                  int visibleAds = 0;
                  return data.isEmpty
                      ? snapshot.errorLoading
                          ? snapshot.noData
                              ? NoPosts(
                                  alignment: Alignment.center,
                                  message: isUser
                                      ? '@${user!.username} has no followers'
                                      : '${challenge!.name} has no pins')
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
                                return UserCard(
                                    User.fromJson(data[index - visibleAds]));
                              }),
                        );
                }),
          )),
        ),
      ),
    );
  }
}

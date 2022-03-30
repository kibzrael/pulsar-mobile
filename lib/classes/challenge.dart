import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/user.dart';
import 'package:pulsar/providers/interactions_sync.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/challenge.dart';
import 'package:pulsar/urls/get_url.dart';

part 'challenge.g.dart';

@JsonSerializable(explicitToJson: true)
class Challenge {
  int id;
  String name;
  String? category;
  String? description;
  Photo cover;
  DateTime? timeCreated;

  @JsonKey(name: 'is_pinned')
  bool isPinned;

  int pins;
  int posts;

  Challenge(this.id,
      {required this.name,
      required this.description,
      this.category,
      required this.cover,
      this.timeCreated,
      this.isPinned = false,
      this.pins = 0,
      this.posts = 0});

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  pin(BuildContext context,
      {RequestMethod mode = RequestMethod.post,
      required Function() onNotify}) async {
    isPinned = mode == RequestMethod.post;
    mode == RequestMethod.post ? pins++ : pins--;
    syncPin(context);
    onNotify();
    User user = Provider.of<UserProvider>(context, listen: false).user;

    String url = getUrl(ChallengeUrls.pins(this));
    http.Response response;
    try {
      if (mode == RequestMethod.post) {
        response = await http
            .post(Uri.parse(url), headers: {'Authorization': user.token ?? ''});
      } else {
        response = await http.delete(Uri.parse(url),
            headers: {'Authorization': user.token ?? ''});
      }
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Success....");
      } else {
        isPinned = !(mode == RequestMethod.post);
        mode == RequestMethod.post ? pins-- : pins++;
        syncPin(context);
        onNotify();
        Fluttertoast.showToast(msg: 'error');
      }
    } catch (e) {
      isPinned = !(mode == RequestMethod.post);
      mode == RequestMethod.post ? pins-- : pins++;
      syncPin(context);
      onNotify();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  syncPin(BuildContext context) {
    InteractionsSync interactionsSync =
        Provider.of<InteractionsSync>(context, listen: false);
    if (isPinned) {
      interactionsSync.pin(this);
    } else {
      interactionsSync.unpin(this);
    }
  }
}

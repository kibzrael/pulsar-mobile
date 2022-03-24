import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/user.dart';
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

  bool isPinned;

  Challenge(this.id,
      {required this.name,
      required this.description,
      this.category,
      required this.cover,
      this.timeCreated,
      this.isPinned = false});

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  pin(BuildContext context, {RequestMethod mode = RequestMethod.post}) async {
    User user = Provider.of<UserProvider>(context).user;

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
        debugPrint("Success....");
      } else {
        debugPrint('error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

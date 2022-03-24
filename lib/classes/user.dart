import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/providers/user_provider.dart';
import 'package:pulsar/urls/get_url.dart';
import 'package:pulsar/urls/user.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int id;
  String username;
  // remove nullable
  String? category;
  String? fullname;
  @JsonKey(name: 'profile_pic')
  Photo? profilePic;
  String? bio;
  String? portfolio;
  List<Interest>? interests;
  String? email;
  String? phone;
  @JsonKey(name: 'date_of_birth')
  DateTime? dateOfBirth;
  @JsonKey(name: 'is_superuser')
  bool isSuperuser;

// name as jwtToken
  @JsonKey(name: 'jwtToken')
  String? token;

  int? followers;
  int? posts;

  @JsonKey(name: 'is_following')
  bool? isFollowing;
  bool? isBlocked;
  bool? postNotifications;

  /// Create a user from info.
  ///
  /// id and username are required
  User(this.id,
      {required this.username,
      required this.category,
      this.bio,
      this.dateOfBirth,
      this.email,
      this.fullname,
      this.interests,
      this.isBlocked,
      this.isFollowing,
      this.phone,
      this.followers,
      this.portfolio,
      this.posts,
      this.profilePic,
      this.isSuperuser = false});

  // Create a user from a json/ map
  //
  // map should contain id and username fields

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  follow(BuildContext context,
      {RequestMethod mode = RequestMethod.post}) async {
    User user = Provider.of<UserProvider>(context).user;

    String url = getUrl(UserUrls.follow(id));
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

  block(BuildContext context, {RequestMethod mode = RequestMethod.post}) async {
    User user = Provider.of<UserProvider>(context).user;

    String url = getUrl(UserUrls.block(id));
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

  report(BuildContext context, Report report) {}

  subcribeForPostNotifications(BuildContext context,
      {RequestMethod mode = RequestMethod.post}) {}

  getPosts() {}

  getReposts() {}

  getFollowers() {}

  // message(Message message) {}

  String? get getProfileUrl {
    // User user = this;
    String url = UserUrls.profile(id);
    return url;
  }

  bool get profileIsComplete {
    List info = [
      id,
      username,
      fullname,
      category,
      profilePic,
      bio,
      posts,
      followers,
      isFollowing
    ];
    return !info.any((element) => element == null);
  }

  getProfile() {}
}

enum RequestMethod { post, delete }

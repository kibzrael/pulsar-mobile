import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pulsar/classes/interest.dart';
import 'package:pulsar/classes/media.dart';
import 'package:pulsar/classes/report.dart';
import 'package:pulsar/urls/user.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int id;
  String username;
  // remove nullable
  String? category;
  String? fullname;
  Photo? profilePic;
  String? bio;
  String? portfolio;
  List<Interest>? interests;
  String? email;
  String? phone;
  DateTime? dateOfBirth;
  bool isSuperuser;

// name as jwtToken
  String? token;

  int? followers;
  int? posts;

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

  follow(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  block(BuildContext context, {RequestMethod mode = RequestMethod.post}) {}

  report(BuildContext context, Report report) {}

  subcribeForPostNotifications(BuildContext context,
      {RequestMethod mode = RequestMethod.post}) {}

  getPosts() {}

  getReposts() {}

  getInterests(BuildContext context) {}

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

  /// Use to edit the class
  User update(BuildContext context, User newUser) {
    // ensure userprovider.id == id

    // username = newUser.username ?? username;
    // bio = newUser.bio ?? bio;
    // category = newUser.category ?? category;
    // dateOfBirth = newUser.dateOfBirth ?? dateOfBirth;
    // email = newUser.email ?? email;
    // fullname = newUser.fullname ?? fullname;
    // interests = newUser.interests ?? interests;
    // phone = newUser.phone ?? phone;
    // portfolio = newUser.portfolio ?? portfolio;
    // profilePic = newUser.profilePic ?? profilePic;
    return this;
  }

  /// Use to edit profile in the server.
  /// Use update to change details.
  ///
  /// Note: editProfile uses the current class values.
  Future<User> editProfile(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));
    return this;
  }

  delete(BuildContext context) {}
}

enum RequestMethod { post, delete }
